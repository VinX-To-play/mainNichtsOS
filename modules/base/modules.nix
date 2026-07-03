{
flake.modules.nixos.pc =
  { lib, ... }:
  let
    dir = ./base;
  
    modules =
      lib.mapAttrsToList
        (name: _: dir + "/${name}")
        (lib.filterAttrs
          (name: type: type == "regular" && lib.hasSuffix ".nix" &&  name != "modules")
          (builtins.readDir dir));
  in
  {
      imports = modules;
  };
}
