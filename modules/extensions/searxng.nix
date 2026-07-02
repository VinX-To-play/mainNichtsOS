{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.vinlabs.searxng;
in {
  options.vinlabs.searxng.enable = mkEnableOption "SearXNG search engine";

  config = mkIf cfg.enable {
    services.searx = {
      enable = true;
      redisCreateLocally = true;
      runInUwsgi = true;
      uwsgiConfig = {
        socket = "/run/searx/searx.sock";
        http = ":8888";
        chmod-socket = "660";
      };
      settings = {
        general = {
          debug = false;
          instance_name = "VinLabs search";
          donation_url = false;
          contact_url = false;
          privacypolicy_url = false;
          enable_metrics = false;
        };
        api_key = false;
        ui = {
          static_use_hash = true;
          default_locale = "en";
          query_in_title = true;
          infinite_scroll = false;
          center_alignment = true;
          default_theme = "simple";
          theme_args.simple_style = "auto";
          search_on_category_select = true;
          hotkeys = "vim";
        };
        search = {
          safe_search = 0;
          autocomplete_min = 2;
          autocomplete = "duckduckgo";
          formats = [ "html" "json" ];
        };
        server = {
          base_url = "https://search.slave.int";
          port = 8888;
          bind_address = "127.0.0.1";
          secret_key = config.sops.secrets."services/searx/key".path;
          limiter = false;
          public_instance = true;
          image_proxy = true;
          method = "GET";
        };
        engines = lib.mapAttrsToList (name: value: { inherit name; } // value) {
          "duckduckgo".disabled = true;
          "brave".disabled = true;
          "bing".disabled = false;
          "mojeek".disabled = true;
          "mwmbl".disabled = false;
          "mwmbl".weight = 0.4;
          "qwant".disabled = true;
          "crowdview".disabled = false;
          "crowdview".weight = 0.5;
          "curlie".disabled = true;
          "ddg definitions".disabled = false;
          "ddg definitions".weight = 2;
          "wikibooks".disabled = false;
          "wikidata".disabled = false;
          "wikiquote".disabled = true;
          "wikisource".disabled = true;
          "wikispecies".disabled = false;
          "wikispecies".weight = 0.5;
          "wikiversity".disabled = false;
          "wikiversity".weight = 0.5;
          "wikivoyage".disabled = false;
          "wikivoyage".weight = 0.5;
          "currency".disabled = true;
          "dictzone".disabled = true;
          "lingva".disabled = true;
          "bing images".disabled = false;
          "brave.images".disabled = true;
          "duckduckgo images".disabled = true;
          "google images".disabled = false;
          "qwant images".disabled = true;
          "1x".disabled = true;
          "artic".disabled = false;
          "deviantart".disabled = false;
          "flickr".disabled = true;
          "imgur".disabled = true;
          "library of congress".disabled = false;
          "material icons".disabled = true;
          "material icons".weight = 0.2;
          "openverse".disabled = false;
          "pinterest".disabled = true;
          "svgrepo".disabled = false;
          "unsplash".disabled = false;
          "wallhaven".disabled = false;
          "wikicommons.images".disabled = false;
          "yacy images".disabled = true;
          "bing videos".disabled = false;
          "brave.videos".disabled = true;
          "duckduckgo videos".disabled = true;
          "google videos".disabled = false;
          "qwant videos".disabled = false;
          "dailymotion".disabled = true;
          "google play movies".disabled = true;
          "invidious".disabled = true;
          "odysee".disabled = true;
          "peertube".disabled = false;
          "piped".disabled = true;
          "rumble".disabled = false;
          "sepiasearch".disabled = false;
          "vimeo".disabled = true;
          "youtube".disabled = false;
          "brave.news".disabled = true;
          "google news".disabled = true;
        };
        outgoing = {
          request_timeout = 30.0;
          max_request_timeout = 60.0;
          pool_connections = 100;
          pool_maxsize = 15;
          enable_http2 = true;
        };
        enabled_plugins = [
          "Basic Calculator"
          "Hash plugin"
          "Tor check plugin"
          "Open Access DOI rewrite"
          "Hostnames plugin"
          "Unit converter plugin"
          "Tracker URL remover"
        ];
      };
    };
    systemd.services.nginx.serviceConfig.ProtectHome = false;
    users.groups.searx.members = [ "nginx" ];
    services.nginx.enable = true;
    services.nginx.recommendedGzipSettings = true;
    services.nginx.recommendedOptimisation = true;
    services.nginx.recommendedProxySettings = true;
    services.nginx.recommendedTlsSettings = true;
    services.nginx.virtualHosts."search.slave.int" = {
      forceSSL = true;
      enableACME = true;
      locations."/".extraConfig = ''
        uwsgi_pass unix:${config.services.searx.uwsgiConfig.socket};
      '';
    };
    sops.secrets."services/searx/key" = {};
  };
}
