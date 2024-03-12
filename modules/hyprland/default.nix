{ pkgs, ... }:

let 
  bemenuOptions = builtins.replaceStrings ["\n"] [" "] ''
    --fn 'FiraCode Nerd Font 14'
    --bottom
    --hp 10
    --line-height 30
    --tb '##2b303b'
    --tf '##81a1c1'
    --fb '##2b303b'
    --ff '##eceff4'
    --sb '##2b303b'
    --sf '##eceff4'
    --nb '##2b303b'
    --nf '##eceff4'
    --ab '##2b303b'
    --af '##eceff4'
    --hb '##2b303b'
    --hf '##81a1c1' 
  '';

  scriptLib = ./lib.sh;
  changeVolume = ./volume.sh;
  changeBrightness = ./brightness.sh;
in
{
  xdg.configFile."hypr/hyprpaper.conf".source = ../../local/hyprpaper.conf;

  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      monitor = " , highres, auto, 1";
      env = [
        "XCURSOR_SIZE, 24"
        "HYPRLAND_SCRIPT_LIB, ${scriptLib}"
      ];
      input = {
        kb_layout = "gb,hu";
        # Toggle keyboard layout on Win + Space
        # Caps Lock is another Escape
        kb_options = "grp:win_space_toggle, caps:escape";
        follow_mouse = 0;
        touchpad = {
          natural_scroll = false;
          scroll_factor = 0.2;
        };
      };

      general = {
        gaps_in = 5;
        gaps_out = 5;
        border_size = 2;
        "col.active_border" =  "rgba(33ccffee) rgba(00ff99ee) 45deg";
        "col.inactive_border" = "rgba(595959aa)";
        
        layout = "dwindle";

        # Please see https://wiki.hyprland.org/Configuring/Tearing/ before you turn this on
        allow_tearing = false;
      };


      dwindle = {
        # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
        pseudotile = true; # master switch for pseudotiling. Enabling is bound to mod + P in the keybinds section below
        preserve_split = true; # you probably want this
      };

      master = {
          # See https://wiki.hyprland.org/Configuring/Master-Layout/ for more
          new_is_master = false;
      };

      gestures = {
        # See https://wiki.hyprland.org/Configuring/Variables/ for more
        workspace_swipe = false;
      };

      misc = {
          # See https://wiki.hyprland.org/Configuring/Variables/ for more
          force_default_wallpaper = 0;
      };

      "$mod" = "SUPER";
      bind = [
        # Example binds, see https://wiki.hyprland.org/Configuring/Binds/ for more
        "$mod, Return, exec, alacritty"
        # "$mod SHIFT, Return, exec, alacritty --working-directory $(pwd)"
        "$mod SHIFT, Q, killactive, "
        "$mod, M, exit, "
        "$mod, E, exec, dolphin"
        "$mod SHIFT, F, togglefloating, "
        "$mod, R, exec, bemenu-run ${bemenuOptions}"
        "$mod, P, pseudo, # dwindle"
        "$mod, V, togglesplit, # dwindle"
        "$mod, F, fullscreen "

        # Move focus with mod + arrow keys
        "$mod, H, movefocus, l"
        "$mod, L, movefocus, r"
        "$mod, K, movefocus, u"
        "$mod, J, movefocus, d"

        "$mod SHIFT, H, swapwindow, l"
        "$mod SHIFT, L, swapwindow, r"
        "$mod SHIFT, K, swapwindow, u"
        "$mod SHIFT, J, swapwindow, d"

        # Switch workspaces with mod + [0-9]
        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4"
        "$mod, 5, workspace, 5"
        "$mod, 6, workspace, 6"
        "$mod, 7, workspace, 7"
        "$mod, 8, workspace, 8"
        "$mod, 9, workspace, 9"
        "$mod, 0, workspace, 10"

        # Move active window to a workspace with mod + SHIFT + [0-9]
        "$mod SHIFT, 1, movetoworkspace, 1"
        "$mod SHIFT, 2, movetoworkspace, 2"
        "$mod SHIFT, 3, movetoworkspace, 3"
        "$mod SHIFT, 4, movetoworkspace, 4"
        "$mod SHIFT, 5, movetoworkspace, 5"
        "$mod SHIFT, 6, movetoworkspace, 6"
        "$mod SHIFT, 7, movetoworkspace, 7"
        "$mod SHIFT, 8, movetoworkspace, 8"
        "$mod SHIFT, 9, movetoworkspace, 9"
        "$mod SHIFT, 0, movetoworkspace, 10"

        # Example special workspace (scratchpad)
        "$mod, S, togglespecialworkspace, magic"
        "$mod SHIFT, S, movetoworkspace, special:magic"

        # Scroll through existing workspaces with mod + scroll
        "$mod, mouse_down, workspace, e+1"
        "$mod, mouse_up, workspace, e-1"
        

      ];

      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];

      binde = [
        "$mod ALT, right, resizeactive, 20 0"
        "$mod ALT, left, resizeactive, -20 0"
        "$mod ALT, up, resizeactive, 0 -20"
        "$mod ALT, down, resizeactive, 0 20"
      ];

      bindel = [
        " , XF86AudioRaiseVolume, exec, ${changeVolume} up"
        " , XF86AudioLowerVolume, exec, ${changeVolume} down"

        " , XF86MonBrightnessUp, exec, ${changeBrightness} up"
        " , XF86MonBrightnessDown, exec, ${changeBrightness} down"
      ];

      bindl = [
        " , XF86AudioMute, exec, ${changeVolume} mute"
      ];
    };

    extraConfig = ''
      exec-once = ${pkgs.waybar}/bin/waybar & hyprpaper

      animations {
        enabled = yes

        bezier = myBezier, 0.05, 0.9, 0.1, 1.05

        animation = windows, 0, 7, myBezier
        animation = windowsOut, 0, 7, default, popin 80%
        animation = windowsMove, 0
        animation = border, 1, 10, default
        animation = borderangle, 0, 8, default
        animation = fade, 0, 7, default
        animation = workspaces, 1, 6, default
      }
    '';
  };
}
