{
  programs.bash = {
  enable = true;
  initExtra = ''
      get_git_info() {
        local branch
        branch=$(git branch --show-current 2>/dev/null)
        if [ -n "$branch" ]; then
          # \001 and \002 tell Bash these are non-printing characters
          echo -e "\001\e[1;35m\002  $branch \001\e[0m\002 |"
        fi
      }

      PROMPT_COMMAND='PS1_CMD1=$(get_git_info)'

      # Use $'\e...' so Bash interprets the escape codes
      BLUE=$'\e[1;34m'
      GREEN=$'\e[1;32m'
      YELLOW=$'\e[1;33m'
      RESET=$'\e[0m'

      # 1. We use " " so the color variables (BLUE, etc.) expand now.
      # 2. We use \$ so the PS1_CMD1 variable expands LATER (every prompt).
      # 3. In Nix, we write ''$ to get a literal $ in the output file.
      PS1="\n\[$BLUE\] \t \[$RESET\]| {$PS1_CMD1}[$GREEN\]  \w \[$RESET\]\n\[$YELLOW\]λ \[$RESET\]"


    # Run fastfetch only in interactive shells
    if [[ $- == *i* ]]; then
      # fastfetch
      :
    fi

    set -o vi


    rebuild_with_commit() {
      echo "⚙️ Rebuilding your NixOS configuration..."
      if sudo nixos-rebuild switch --flake .# ; then
        echo "✅ Rebuild succeeded."

        # Prompt for commit
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
}
