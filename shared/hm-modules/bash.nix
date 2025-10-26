{
  programs.bash = {
  enable = true;
  initExtra = ''
    # Run fastfetch only in interactive shells
    if [[ $- == *i* ]]; then
      # fastfetch
      :
    fi

    set -o vi


    rebuild_with_commit() {
      echo "⚙️ Rebuilding your NixOS configuration..."
      if sudo nixos-rebuild switch --flake .# --show-trace; then
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
