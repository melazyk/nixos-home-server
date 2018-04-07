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
  # boot.loader.grub.efiSupport = true;
  # boot.loader.grub.efiInstallAsRemovable = true;
  # boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # Define on which hard drive you want to install Grub.
  boot.loader.grub.devices = [ "/dev/sde" "/dev/sdf" ]; # or "nodev" for efi only

  networking.hostName = "poni.nkfs"; # Define your hostname.
  networking.interfaces.enp0s31f6.ipv4.addresses = [
	{ address = "192.168.0.3"; prefixLength = 24; }
  ];
  networking.defaultGateway = "192.168.0.1";
  networking.nameservers = [ "8.8.8.8" "8.8.4.4" ];
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
  environment.systemPackages = with pkgs; [
     curl wget vim git zfs zfstools docker
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  #programs.bash.enableCompletion = true;
  #programs.mtr.enable = true;
  #programs.gnupg.agent = { enable = true; enableSSHSupport = true; };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
   networking.firewall.allowedTCPPorts = [ 22 80 443 ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = false;

  # Enable sound.
  sound.enable = false;
  hardware.pulseaudio.enable = false;

  # Enable the X11 windowing system.
  services.xserver.enable = false;
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable touchpad support.
  # services.xserver.libinput.enable = true;

  # Enable the KDE Desktop Environment.
  # services.xserver.displayManager.sddm.enable = true;
  # services.xserver.desktopManager.plasma5.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  # users.extraUsers.guest = {
  #   isNormalUser = true;
  #   uid = 1000;
  # };
  #
  users.groups.melazyk.gid = 1000;
  users.extraUsers.melazyk = {
	uid = 1000;
	isNormalUser = true;
	home = "/home/melazyk";
	extraGroups = [ "melazyk" "wheel" "docker" ];
  	openssh.authorizedKeys.keys = [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDSbqflE9I05rRMtcurw1GPEG3C6lw+0OHN93BmW8s/GBfDlI9H2tFBzGe4wRrrn97xSsaD7BSftxmaYTCZvSCaxnmElgNZbYElfX9AiYlFGp+YSQYuQU92jHuDkRzbTYuatLlcCzY1/rWUSNdF/Vywij/uqvmj15bEF40wVKTwz2l8v6jSF70uXDu/9cVDY0eqsgsNywxITsrhlIYDDX2iCi1J70A7Fwo/AprTKTqKU9Wpm7KMmYITKk2VR4UVkNmeb+PXXvziXmxd15ofWdxkCUrspRL8tVLXFKqswDkNYHHmeKaurFwsljSpK14NGciWJx1sD4sgLAHVHh5ztmmpu4iQO1EpXjZxgodjONFq8i/gaIA/V4v9nNtDe+hUgokp5Y45TP2SPN5mMQAzdqU+hn66Ry/pP0FYVE5RnADXiMI0ps3RECgaRSxEZ/oaF/AWpDpxsrM9vMtXwlasBHy3/bkU4DNI06j66lzQWmS6Z1s7pXdFU3O30l830AFsER0IhG1jOQXGLriEiYsgV+cgBlvcXYOHk5mKS/xYslMnf8hSeR6aTm7aXaN00IhSQiN2X++YU1N174dQGQZ8VokOm06awqgjRd9XN7SGmYvHc2APCwnekmw6PxA5ACUjmpYnGcDeiGbrKSqI65IHaUvaeUW50u2tVCGzUppdbipKNQ== melazyk@workbox" ];
  };

  virtualisation.docker.enable = true;
  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "18.03"; # Did you read the comment?

}
