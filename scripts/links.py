import os
import sys
import json
import stat
from typing import Dict, Tuple, List
from enum import Enum

def ln_file(path: str) -> Tuple[str, str]:
    return ("file", path)

def ln_dir(path: str) -> Tuple[str, str]:
    return ("dir", path)

def shell_expand(path: str) -> str:
    home = os.environ["HOME"]
    path = path.replace("$HOME", home)
    return path

def abspath(path: str) -> str:
    return os.getcwd() + "/" + path

def relpath(path: str) -> str:
    return path.replace(os.getcwd() + "/", "")

LinkDef = Tuple[str, Tuple[str, str]]
LockFile = Dict[str, Dict[str, any]]

def read_lockfile(path: str) -> LockFile:
    with open(path, "r", encoding="utf8") as f:
        lock = json.load(f)
        return lock

class SourceResult(Enum):
    NOT_FOUND = 1
    NOT_IN_LOCKFILE = 2
    FOUND = 3

def source_exists(source: str) -> bool:
    return os.path.exists(source)

class TargetResult(Enum):
    # Target path does not exist
    NOT_FOUND = 1
    # Target path exists, but is not a directory or file 
    INVALID_TYPE = 3
    # Target path exists, but the symlink is broken
    BAD_LINK = 5
    # Target path exists, but is not a symlink
    NOT_LINK = 6
    # Target OK
    FOUND = 8

def check_target(target: str) -> TargetResult:
    if not os.path.exists(target):
        return TargetResult.NOT_FOUND

    # Don't follow symlinks at first
    link_stat = os.lstat(target)
    if not stat.S_ISLNK(link_stat.st_mode):
        return TargetResult.NOT_LINK

    # 
    try:
        orig_stat = os.stat(target)
    except:
        return TargetResult.BAD_LINK

    mode = orig_stat.st_mode
    if not (stat.S_ISDIR(mode) or stat.S_ISREG(mode)):
        return TargetResult.INVALID_TYPE

    return TargetResult.FOUND

def target_real_path(source_rel: str, target: str) -> str:
    # source is assumed to exist here
    source_mode = os.stat(abspath(source_rel)).st_mode
    target_dir = target.endswith("/")
    if stat.S_ISREG(source_mode) and target_dir:
        return target + source_rel
    elif stat.S_ISDIR(source_mode) and not target_dir:
        raise Exception(f"{source} directory cannot be linked to target file: {target}")
    elif stat.S_ISREG(source_mode) or stat.S_ISDIR(source_mode):
        return target
    else:
        raise Exception(f"Invalid source path: {source_rel}")

def mtime_or_zero(path: str) -> int:
    try:
        return os.stat(path).st_mtime
    except:
        return 0

# TODO delete unnecessary lockfile entries and their symlinks

links = {
    # "alacritty.toml": "$HOME/.config/alacritty/",
    "nvim/":  "$HOME/.config/nvim/",
    "pacman.conf": "/etc/pacman.conf",
}

# links = [
#     (abspath(key), shell_expand(value))
#     for (key, value) in links
# ]

if __name__ == "__main__":
    # Make sure source files are valid
    err = False
    # Map link source absolute paths to defined (relative) paths
    abs_source_map = {}
    for (source, _) in links.items():
        source_abs = abspath(source)
        if not source_exists(source):
            print(f"{source} does not exist")
            err = True
        else:
            abs_source_map[source_abs] = source
    if err:
        sys.exit(1)

    # Make sure we don't overwrite existing files
    err = False 
    target_info = {}
    target_real_paths = {}
    for (source, target) in links.items():
        target_path = shell_expand(target)
        target_real = target_real_path(source, target_path)
        target_stat = check_target(target_real)
        # print(target_real, "->", target_stat)
        if target_stat == TargetResult.INVALID_TYPE:
            err = True
            print(f"{target} path is not a link to regular file or directory")
        elif target_stat == TargetResult.NOT_LINK:
            err = True
            print(f"{target} path is not a symlink")
        else:
            target_info[target] = target_stat
            target_real_paths[target] = target_real

    # print(target_info)
    if err:
        sys.exit(1)
        pass

    # Check links against lockfile (contains absolute paths).
    actions = []
    try:
        lockfile = read_lockfile("links.lock")
    except FileNotFoundError:
        lockfile = {}
    for (lock_source, lock_target) in lockfile.items():
        if not (lock_source in abs_source_map):
            actions.append(("delete", lock_source, lock_target["target"]))
            continue
        
        source = abs_source_map[lock_source]
        target = target_real_paths[links[source]]
        # Check if target is newer. It shouldn't be
        target_stat = target_info[target]
        if target_stat == TargetResult.NOT_FOUND:
            actions.append(("create", lock_source, lock_target))
        elif target_stat == BAD_LINK:
            actions.append(("create", lock_source, lock_target))
        else:
            disk_mtime = mtime_or_zero(target_real_paths[target])
            raise Exception("TODO compare mtimes")

    # Add new entries to lockfile
    for (source, target) in links.items():
        source_real = abspath(source)
        target_real = target_real_paths[target]
        if not (source_real in lockfile):
            # TODO privile escalation for root paths?
            actions.append(("create", source_real, target_real))
            continue

        # At this point the lockfile target file **should** exist
        lock_target = lockfile[source_real]
        lock_target_path = lock_target["target"]
        if lock_target_path != target_real:
            actions.append(("delete", source_real, lock_target_path))
            actions.append(("create", source_real, target_real))
            continue

        lock_target_mtime = lock_target["modified"]
        disk_mtime = mtime_or_zero(target_real)
        if disk_mtime > lock_mtime:
            raise Exception("TODO is this an error?")
            continue

        actions.append(("create", source_real, target_real))

    for action in actions:
        print(f"{action[0].upper()} {relpath(action[1])} -> {action[2]}")
    
    input_str = ""
    while input_str not in ["y", "n"]:
        input_str = input("OK? [y/n] ")

    if input_str == "n":
        sys.exit(0)

    new_lockfile = lockfile
    for action in actions:
        action_kind, source, target = action
        match action_kind:
            case "create":
                os.symlink(source, target)
                new_lockfile[source] = {
                    "target": target,
                    "modified": os.lstat(target).mtime,
                }
            case "delete":
                # This should always be a file, right?
                os.remove(target)
                del new_lockfile[source]
    print(json.dumps(new_lockfile))

