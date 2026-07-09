{...}: {
flake.nixosModules.base = {
  nix.settings = {
    show-trace = true;
    experimental-features = [ "nix-command" "flakes" ];
    trusted-users = [ "root" "vincentl" "@wheel" ];
    substituters = [
      "https://nix.slave.int"
      "https://cache.nixos.org"
    ];
    trusted-public-keys = [
      "vincent-cache-1:9r9bePSUWsLD4yHr7VA0WOEda71CQNbLngUYBkBgcsM="
      "hydra.nixos.org-1:CNHJZBh9K4tP3EKF6FkkgeVYsS3ohTl+oS0Qa8bezVs=" 
    ];
    # TODO add optimise.automatic = true;
  };
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };
  nixpkgs.config = {
    allowUnfree = true;
  };
};
}
