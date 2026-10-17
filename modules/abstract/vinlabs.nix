{lib,...}:{
  options.vinlabs = {
    prometheus-exporters = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = "List of exportes automaticly added to the promethus";
    };
  };
}



