{
  programs.bash = {
  enable = true;
  initExtra = ''
      # Function to get git branch with an icon
      get_git_info() {
        local branch
        branch=$(git branch --show-current 2>/dev/null)
        if [ -n "$branch" ]; then
          # Format:  branch_name
          echo -e " \001\e[35m\002\uf126 $branch\001\e[0m\002 |"
        fi
      }

      PROMPT_COMMAND='PS1_CMD1=$(get_git_info)'

      # Color Definitions
      # \001 and \002 are equivalents to \[ and \] for non-printing characters
      BLUE="\[\e[1;34m\]"
      CYAN="\[\e[1;36m\]"
      GREEN="\[\e[1;32m\]"
      RESET="\[\e[0m\]"

      PS1="\n''${BLUE} \t ''${RESET}|''${PS1_CMD1} ''${GREEN} \w ''${RESET}\nλ "

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
