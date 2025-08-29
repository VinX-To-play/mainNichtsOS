{
  programs.bash = {
  enable = true;
  initExtra = ''
    # Run fastfetch only in interactive shells
    if [[ $- == *i* ]]; then
      fastfetch
    fi

    export test=true

    set -o vi
  '';
};
}
