{ specialArgs, ... }:

{
  programs.go = {
    enable = true;
    package = specialArgs.unstable.go_1_22;
    goBin = ".local/bin";
    # TODO use go 1.22 from unstable
  };
}
