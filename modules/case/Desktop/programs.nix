{inputs, ...}: {
  flake.nixosModules.Desktop = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
    # Tools
    figlet
    ripgrep
    tldr

    #Media
    jellyfin-ffmpeg
    deluge
    mpv
    psst
    spotify-player

    #Web
    inputs.zen-browser.packages."${system}".specific
    psst
    vesktop
    discord

    #Office
    # libreoffice-qt brocken
    obsidian
    thunderbird
    koreader
 
    # Programing
    jetbrains.idea
    vscode-fhs
    gradle

    # Programing lange
    # rust dependency installd throu nixvim
    python3
    gcc

    # Gaming
    heroic

    # Wayland & Display:
    wlroots_0_20
    egl-wayland
    
    helium
    #(pkgs.callPackage ../../../pkgs/helium/package.nix {})
    ];
  };
}
