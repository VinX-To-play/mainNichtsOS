{
  programs.bash = {
  enable = true;
  initExtra = ''
      get_git_info() {
        local branch
        branch=$(git branch --show-current 2>/dev/null)
        if [ -n "$branch" ]; then
          # We use \001 and \002 here which are the internal bash codes for \[ and \]
          echo -e "\001\e[1;35m\002  $branch \001\e[0m\002 |"
        fi
      }

      PROMPT_COMMAND='PS1_CMD1=$(get_git_info)'

      # Defined without literal \[ \] to avoid double-escaping issues
      BLUE=$'\e[1;34m'
      GREEN=$'\e[1;32m'
      YELLOW=$'\e[1;33m'
      RESET=$'\e[0m'

      # We use double quotes here so the variables expand into the prompt
      # We use \[ and \] directly in the string to tell bash these are non-printing
      PS1="\n\[$BLUE\] \t \[$RESET\]|''${PS1_CMD1}\[$GREEN\]  \w \[$RESET\]\n\[$YELLOW\]λ \[$RESET\]"
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
