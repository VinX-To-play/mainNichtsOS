{ ... }: {
  services.samba = {
    enable = true;
    shares = {
      libary = {
	path = "/srv/shared/libary";
	comment = "Network folder for ebooks";
	browseable = true;
	"read only" = false;
	"guest ok" = true;
      };
    };
  };
  networking.firewall.allowedTCPPorts = [ 445 ];
}
