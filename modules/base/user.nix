{
flake.modules.nixos.base.user = {
  users.users.vincentl = {
    isNormalUser = true;
    description = "Vincent Lundborg";
    extraGroups = [ "networkmanager" "wheel" "dialout" ];
  };
};
}
