{self, ...}:{
  flake.nixosModules.gaming = {...}: {
    # home.shearedModules = [ self.homeModules.gaming ];
  };
}
