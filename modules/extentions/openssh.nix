{...}:{
  flake.nixosModules.openssh = {...}:{
    services.openssh = {
      enable = true;
      openFirewall = true;
      settings = {
        PasswordAuthentication = true; # TODO setup ssh managment
        AllowUsers = ["vincentl"];
      }
      ;
    };
  };
}
