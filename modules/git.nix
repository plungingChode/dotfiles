{
  programs.git = {
    enable = true;
    aliases = {
      s = "status -s";
      l = "log --pretty=oneline -n 20 --graph --abbrev-commit";
      hist = "log --decorate --pretty=format:'%C(yellow)%h%C(reset) %ad | %s%d [%an]' --graph --date=short";
    };
    extraConfig = {
      user = import ../local/git_user.nix;
      init.defaultBranch = "master";
      credential.helper = "store";
      pull.ff = "only";
      merge.conflictstyle = "diff3";
      diff = {
        colorMoved = "default";
        noprefix = true;
        tool = "vimdiff";
      };
    };
    delta = {
      enable = true;
      options = {
        navigate = true;    # use n and N to move between diff sections
        light = false;     # set to true if you're in a terminal w/ a light background color (e.g. the default macOS terminal)
        side-by-side = true;
        line-numbers = true;
      };
    };
  };
}
