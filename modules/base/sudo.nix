{ pkgs, ... }: {
  security.sudo.extraRules = [
    {
      users = [ "vincentl" ];
      commands = [
        {
          command = "${pkgs.nixos-rebuild}/bin/nixos-rebuild";
          options = [ "NOPASSWD" ];
        }
      ];
    }
  ];
}
