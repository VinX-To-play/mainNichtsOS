{ ... }: {
  services.samba = {
    enable = true;
    shares = {
      libary = {
	path = "/srv/shared/libary";
	comment = "Network folder for ebooks";
	browseable = true;
	"read only" = false;
	"guest ok" = false;
	"valid users" = [ "smbUser" ];
	"create mask" = "0664";
      	"directory mask" = "0775";
      	"force user" = "smbUser";
      };
    };
  };
  networking.firewall.allowedTCPPorts = [ 445 ];
  
  users.users.smbUser = {
    isSystemUser = true;
    group = "smbUser";
  };
  users.groups.smbUser = {};
}
