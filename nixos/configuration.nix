# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.supportedFilesystems = [ "zfs" ];
  boot.loader.grub.devices = [ "/dev/sde" "/dev/sdf" ]; # or "nodev" for efi only
  boot.extraModprobeConfig = "options zfs zfs_arc_max=16307338";

  networking.hostId = "d6a8a37e";
  networking.hostName = "poni.nkfs"; # Define your hostname.
  networking.interfaces.enp0s31f6.ipv4.addresses = [
    { address = "192.168.0.3"; prefixLength = 24; }
  ];
  networking.defaultGateway = "192.168.0.1";
  networking.nameservers = [ "8.8.8.8" "8.8.4.4" ];

  services.zfs.autoScrub.enable = true;
  services.zfs.autoSnapshot.enable = true;

  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Select internationalisation properties.
  # i18n = {
  #   consoleFont = "Lat2-Terminus16";
  #   consoleKeyMap = "us";
  #   defaultLocale = "en_US.UTF-8";
  # };

  # Set your time zone.
  time.timeZone = "Europe/Moscow";

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
     curl wget unzip tcpdump binutils vim git zfs zfstools fio iozone docker screen smartmontools sysstat dmidecode
     lsof file syslogng nmap
     plex transmission nginx openvpn netatalk avahi nssmdns samba
     syncthing
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  #programs.bash.enableCompletion = true;
  #programs.mtr.enable = true;
  #programs.gnupg.agent = { enable = true; enableSSHSupport = true; };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.openssh.permitRootLogin = "no";

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [
        80 443 9091
        548 # afp mac share
        445 139 # smb share
        8384 # syncthing
  ];
  networking.firewall.allowedUDPPorts = [
    137 138 # NetBios
    514 # syslog
  ];

  # Or disable the firewall altogether.
  networking.firewall.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = false;

  # Enable sound.
  sound.enable = false;
  hardware.pulseaudio.enable = false;

  # Enable the X11 windowing system.
  services.xserver.enable = false;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.groups.melazyk.gid = 1000;
  virtualisation.docker.enable = true;
  system.stateVersion = "18.03";

  users.extraUsers = {
        melazyk = {
            uid = 1000;
            isNormalUser = true;
            home = "/home/melazyk";
            extraGroups = [ "melazyk" "wheel" "docker" "plex" "transmission" ];
            openssh.authorizedKeys.keys = [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDSbqflE9I05rRMtcurw1GPEG3C6lw+0OHN93BmW8s/GBfDlI9H2tFBzGe4wRrrn97xSsaD7BSftxmaYTCZvSCaxnmElgNZbYElfX9AiYlFGp+YSQYuQU92jHuDkRzbTYuatLlcCzY1/rWUSNdF/Vywij/uqvmj15bEF40wVKTwz2l8v6jSF70uXDu/9cVDY0eqsgsNywxITsrhlIYDDX2iCi1J70A7Fwo/AprTKTqKU9Wpm7KMmYITKk2VR4UVkNmeb+PXXvziXmxd15ofWdxkCUrspRL8tVLXFKqswDkNYHHmeKaurFwsljSpK14NGciWJx1sD4sgLAHVHh5ztmmpu4iQO1EpXjZxgodjONFq8i/gaIA/V4v9nNtDe+hUgokp5Y45TP2SPN5mMQAzdqU+hn66Ry/pP0FYVE5RnADXiMI0ps3RECgaRSxEZ/oaF/AWpDpxsrM9vMtXwlasBHy3/bkU4DNI06j66lzQWmS6Z1s7pXdFU3O30l830AFsER0IhG1jOQXGLriEiYsgV+cgBlvcXYOHk5mKS/xYslMnf8hSeR6aTm7aXaN00IhSQiN2X++YU1N174dQGQZ8VokOm06awqgjRd9XN7SGmYvHc2APCwnekmw6PxA5ACUjmpYnGcDeiGbrKSqI65IHaUvaeUW50u2tVCGzUppdbipKNQ== melazyk@workbox" ];
        };
        plex = {
            createHome = true;
            home = "/home/plex";
        };
        timemachine = {
            createHome = true;
            home = "/data/timemachine";
        };
  };

  services.openvpn.servers = {
    yourheroVPN = { config = '' config /root/configs/openvpn/poni.nkfs.ovpn ''; };
  };

  services.plex.extraPlugins = ["/home/plex/plugins/Kinopub.bundle"];
  services.plex.enable = true;
  services.plex.openFirewall = true;

  services.transmission.enable = true;
  services.transmission.settings = {
    download-dir = "/data/torrents/";
    incomplete-dir-enabled = false;
    rpc-host-whitelist = "172.16.1.*";
    rpc-whitelist = "172.16.1.*,box.yourhero.ru";
  };

  services.nginx.enable = true;
  services.nginx.recommendedOptimisation = true;
  services.nginx.statusPage = true;
  services.nginx.resolver.addresses = [ "192.168.0.1" ];
  services.nginx.virtualHosts = {
    "poni.nkfs" = {
        listen  = [
            { addr = "0.0.0.0"; port = 80; }
        ];
        locations."/" = {
            proxyPass =  "http://127.0.0.1:8384";
        };
    };
  };

  services.netatalk.enable = true;
  services.netatalk.volumes = {
    "TimeMachine_AFP" = {
        "time machine" = "yes";
        path = "/data/timemachine";
        "valid users" = "timemachine";
    };
  };

  services.avahi = {
        enable = true;
        nssmdns = true;
        hostName = "poni";

        publish = {
            enable = true;
            userServices = true;
        };
  };

  services.samba = {
    enable = true;
    package = pkgs.sambaMaster;
    syncPasswordsByPam = true;
    extraConfig = ''
        workgroup = WORKGROUP
        server string = poni.nkfs
        netbios name = poni.nkfs
        hosts allow = 192.168.0. localhost
        hosts deny = 0.0.0.0/0
        guest account = nobody
        map to guest = bad user
    '';
    shares = {
        public = {
            browseable = "yes";
            comment = "Public samba share";
            "guest ok" = "yes";
            path = "/data/public";
            "read only" = "no";
        };
        timemachine_smb = {
            path = "/data/timemachine";
            "valid users" = "timemachine";
            public = "no";
            writeable = "yes";
            "force user" = "timemachine";
            "force group" = "wheel";
            browseable = "yes";
            comment = "Time Machine";
            "fruit:aapl" = "yes";
            "fruit:time machine" = "yes";
            "vfs objects" = "catia fruit streams_xattr";
        };
    };
  };

  services.syncthing = {
      dataDir = "/data/syncthing";
      enable = true;
      openDefaultPorts = true;
  };

  services.syslog-ng = {
      enable = true;
      extraConfig = ''
        source syslog_udp { udp(port(514)); };
        destination extlog { file("/var/log/external.log"); };
        filter intnet { netmask(192.168.0.0/255.255.255.0)};
        log {
            source(syslog_udp);
            filter(intnet);
            destination(extlog);
        };
      '';
  };

  services.cron = {
    enable = true;
    systemCronJobs = [
        "35 * * * *     root    /data/system/sbin/update_rkn.sh > /data/logs/update_rkn.log 2>&1"
    ];
  };
}
