{ pkgs, specialArgs, ... }:

{
  services.dunst = {
    enable = true;
    settings = {
      global = {
        # TODO
        font = "Open Sans 12";
        markup = true;

        # The format of the message.  Possible variables are:
        #   %a  appname
        #   %s  summary
        #   %b  body
        #   %i  iconname (including its path)
        #   %I  iconname (without its path)
        #   %p  progress value if set ([  0%] to [100%]) or nothing
        # Markup is allowed
        format = "<b>%s</b>\\n%b";
        # Sort messages by urgency.
        sort = false;
        # Show how many messages are currently hidden (because of geometry).
        indicate_hidden = true;
        # Alignment of message text.
        # Possible values are "left", "center" and "right".
        alignment = "left";
        # Show age of message if message is older than show_age_threshold
        # seconds. Set to -1 to disable.
        show_age_threshold = -1;
        # Split notifications into multiple lines if they don't fit into
        # geometry.
        word_wrap = true;
        
        # Ignore newlines '\n' in notifications.
        ignore_newline = false;
        
        # Hide duplicate's count and stack them
        stack_duplicates = true;
        hide_duplicate_count = true;

        # The geometry of the window:
        #   [{width}]x{height}[+/-{x}+/-{y}]
        width = "450";
        origin = "top-right";
        offset = "15x30";

        # Shrink window if it's smaller than the width.  Will be ignored if
        # width is 0.
        shrink = false; 

        # The transparency of the window.  Range: [0; 100].
        # This option will only work if a compositing windowmanager is
        # present (e.g. xcompmgr, compiz, etc.).
        transparency = 5;

        # Don't remove messages, if the user is idle (no mouse or keyboard
        # input) for longer than idle_threshold seconds. Set to 0 to disable.
        idle_threshold = 0;

        # Display notification on focused monitor.  Possible modes are:
        #   mouse: follow mouse pointer
        #   keyboard: follow window with keyboard focus
        #   none: don't follow anything
        follow = "keyboard";

        # Should a notification popped up from history be sticky or timeout as
        # if it would normally do.
        sticky_history = true;
        
        # Maximum amount of notifications kept in history
        history_length = 15;
        
        # Display indicators for URLs (U) and actions (A).
        # show_indicators = false;
        show_indicators = true;

        # The height of a single line.  If the height is smaller than the
        # font height, it will get raised to the font height.
        # This adds empty space above and under the text.
        line_height = 0;
        
        # Draw a line of "separatpr_height" pixel height between two
        # notifications.
        # Set to 0 to disable.
        separator_height = 2;
        
        # Padding between text and separator.
        padding = 10;
        
        # Horizontal padding.
        horizontal_padding = 18;
        
        # Define a color for the separator.
        # possible values are:
        #  * auto: dunst tries to find a color fitting to the background;
        #  * foreground: use the same color as the foreground;
        #  * frame: use the same color as the frame;
        #  * anything else will be interpreted as a X color.
        separator_color = "auto";
        
        # dmenu path.
        dmenu = "${pkgs.rofi}/bin/rofi -dmenu -p dunst:";
        
        # TODO
        # Browser for opening urls in context menu.
        browser = "${pkgs.firefox-devedition-bin}/bin/firefox-developer-edition --new-tab";
        
        # Align icons left/right/off
        icon_position = "left";
        max_icon_size = 32;
        
        # Paths to default icons.
        # TODO add the other maia icons, not just 22
        icon_path = "${specialArgs.unstable.papirus-maia-icon-theme}/share/icons/breeze/status/22";

        # Appearance
        frame_width = 0;
        frame_color = "#8EC07C";
      };

      urgency_low = {
        frame_color = "#3B7C87";
        #foreground = "#3B7C87";
        #background = "#191311";
        background = "#222222";
        foreground = "#bbbbbb";
        timeout = 4;
      };

      urgency_normal = {
        frame_color = "#5B8234";
        #foreground = "#5B8234";
        #background = "#191311";
        background = "#222222";
        foreground = "#bbbbbb";
        #background = "#2B313C";
        timeout = 6;
      };

      urgency_critical = {
        frame_color = "#B7472A";
        foreground = "#B7472A";
        background = "#191311";
        #background = "#2B313C"
        timeout = 10;
      };

      # Every section that isn't one of the above is interpreted as a rules to
      # override settings for certain messages.
      # Messages can be matched by "appname", "summary", "body", "icon", "category",
      # "msg_urgency" and you can override the "timeout", "urgency", "foreground",
      # "background", "new_icon" and "format".
      # Shell-like globbing will get expanded.
      #
      # SCRIPTING
      # You can specify a script that gets run when the rule matches by
      # setting the "script" option.
      # The script will be called as follows:
      #   script appname summary body icon urgency
      # where urgency can be "LOW", "NORMAL" or "CRITICAL".
      #
      # NOTE: if you don't want a notification to be displayed, set the format
      # to "".
      # NOTE: It might be helpful to run dunst -print in a terminal in order
      # to find fitting options for rules.
      Spotify = {
        appname = "Spotify";
        format = "<b>%s</b>\\n%b";
      };
    };
  };
}
