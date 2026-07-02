{ pkgs, config, ... }: {
  home-manager.users.vincentl = { pkgs, ... }: {
    home.packages = with pkgs; [
      nemo-with-extensions
      unzip
    ];

    # TODO maybe move to Helimu package
    xdg.mimeApps = {
      enable = true;
      defaultApplications = {
        "x-scheme-handler/http" = [ "Helium.desktop" ];
        "x-scheme-handler/https" = [ "Helium.desktop" ];
        "text/html" = [ "Helium.desktop" ];
      };
    };

    programs.direnv.enable = true;
    programs.direnv.nix-direnv.enable = true;

    programs.git = {
      enable = true;
      settings = {
        user = {
          email = "v@lundborgs.de";
          name = "VinX-To-play";
        };
        pull = {
          rebase = false;
          autoSetupRemote = true;
        };
      };
    };

    programs.bash = {
      enable = true;
      initExtra = ''
        get_git_info() {
          local branch
          local git
          branch=$(git branch --show-current 2>/dev/null)
          if [ -n "$branch" ]; then
            git=$"\001\e[1;35m\002  $branch \001\e[0m\002 |"
          fi

          BLUE=$'\e[1;34m'
          GREEN=$'\e[1;32m'
          YELLOW=$'\e[1;33m'
          RESET=$'\e[0m'

          PS1="\n\[$BLUE\] \t \[$RESET\]| $git \[$GREEN\]  \w \[$RESET\]\n\[$YELLOW\]λ \[$RESET\]"
        }

        PROMPT_COMMAND="get_git_info"

        if [[ $- == *i* ]]; then
          :
        fi

        set -o vi

        rebuild_with_commit() {
          echo "⚙️ Rebuilding your NixOS configuration..."
          if sudo nixos-rebuild switch --flake .# ; then
            echo "✅ Rebuild succeeded."

            read -rp "Commit: " msg

            if [ -z "$msg" ]; then
              msg="Update $(date '+%Y-%m-%d %H:%M:%S')"
            fi

            git add .
            git commit -am "$msg"
            git push
            echo "✅ Committed and pushed: '$msg'"
          else
            echo "❌ Rebuild failed — no changes committed."
          fi
        }

        alias nix-rebuild="rebuild_with_commit"
      '';
    };

    programs.kitty = {
      enable = true;
      settings = {
        enable_audio_bell = false;
        confirm_os_window_close = 0;
      };
    };
  };
}
