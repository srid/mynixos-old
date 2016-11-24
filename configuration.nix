# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.grub.enable = false;
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.cleanTmpDir = true;
  boot.extraModprobeConfig = ''
    options libata.force=noncq
    options resume=/dev/sda3
    options snd_hda_intel index=0 model=intel-mac-auto id=PCH
    options snd_hda_intel index=1 model=intel-mac-auto id=HDMI
    options snd_hda_intel model=mbp101
    options hid_apple fnmode=2
  '';

  nixpkgs.config.allowUnfree = true;
  hardware.opengl.driSupport32Bit = true;

  networking.hostName = "nixbook"; # Define your hostname.
  networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # hardware.bluetooth.enable = true;
  hardware.facetimehd.enable = true;
  hardware.pulseaudio.enable = true;
  hardware.opengl.extraPackages = [ pkgs.vaapiIntel ];

  powerManagement.enable = true;

  # Select internationalisation properties.
  # i18n = {
  #   consoleFont = "Lat2-Terminus16";
  #   consoleKeyMap = "us";
  #   defaultLocale = "en_US.UTF-8";
  # };

  # Set your time zone.
  time.timeZone = "Asia/Kolkata";

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    # X
    dmenu
    xorg.xclock
    xorg.xmodmap

    # Web
    chromium
    opera

    # Development tools
    wget
    vim
    emacs
    htop
    ag
    git
    gitAndTools.tig

    kde5.konsole

    # Languages and libraries
    ghc
    haskellPackages.stack
    haskellPackages.purescript

    nodejs
    nodePackages.grunt-cli
    nodePackages.gulp
    nodePackages.bower

    # Games
    wesnoth
  ];

  fonts.fonts = with pkgs; [
    inconsolata
    fira-code
  ];

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Enable CUPS to print documents.
  # services.printing.enable = true;
# Enable the X11 windowing system.
  # services.xserver.enable = true;
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable the KDE Desktop Environment.
  # services.xserver.displayManager.kdm.enable = true;
  # services.xserver.desktopManager.xfce.enable = true;
  #
 
  services.xserver = {
    enable = true;
    layout = "us";
    xkbVariant = "mac";
    xkbOptions = "terminate:ctrl_alt_bksp, ctrl:nocaps";


    multitouch.enable = true;
    multitouch.invertScroll = true;

    synaptics.additionalOptions = ''
      Option "VertScrollDelta" "-100"
      Option "HorizScrollDelta" "-100"
    '';
    synaptics.enable = true;
    synaptics.tapButtons = true;
    synaptics.fingersMap = [ 0 0 0 ];
    synaptics.buttonsMap = [ 1 3 2 ];
    synaptics.twoFingerScroll = true;

    videoDrivers = [ "nvidia" ];
    displayManager.lightdm.enable = true;

    windowManager.xmonad.enable = true;
    windowManager.xmonad.enableContribAndExtras = true;
    # windowManager.xmonad.extraPackages = self: [ self.xmonadContrib ];
    # windowManager.default = "xmonad";

    desktopManager.xterm.enable = false;
    desktopManager.xfce.enable = true;
    desktopManager.default = "xfce";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.extraUsers.srid = {
    isNormalUser = true;
    uid = 1000;
  };

  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "16.09";

}
