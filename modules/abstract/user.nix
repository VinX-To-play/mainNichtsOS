{lib, ...}:{
  options.flake.meta = {
    username = lib.mkOption {
      default = "vincentl";
    };

    baseurl = lib.mkOption {
      default = "elin.love";
    };
  };
}
