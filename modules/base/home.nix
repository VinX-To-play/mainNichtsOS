{ inputs, config, ... }:
let 
  user = config.flake.meta.username;
in {
  imports = [ inputs.home-manager.flakeModules.home-manager ];

  flake.nixosModules.base = {...}: {
    imports = [ 
      inputs.home-manager.nixosModules.home-manager 
    ];
    
    # TODO set to false after automaticly setting password
    users.mutableUsers = true;
    
    users.users.${user} = {
      isNormalUser = true;
      # TODO set users hashedPassword 
      extraGroups = [
        "wheel"
      ];
    };
    
    nix.settings.trusted-users = [user];

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;

      users.${user} = {... }: {
        home = {
          username = user;
          homeDirectory = "/home/${user}";
        };
      };
    };
  };

}
