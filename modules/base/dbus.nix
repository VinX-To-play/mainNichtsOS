{...}: {
flake.nixosModules.base = {...}: {
    services.dbus = {
      enable = true;
      implementation = "broker";
    };
  };
}
