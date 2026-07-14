# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{ config, pkgs, ... }:
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];
  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelParams = [ "amd_iommu=on" ];
  boot.kernelModules = [ "vfio_pci" "vfio" "vfio_iommu_type1" ];
  boot.blacklistedKernelModules = [ "nouveau" ];
  boot.extraModprobeConfig = ''
  options vfio-pci ids=10de:1c82,10de:0fb9
'';
  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Confiigure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/London";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_GB.UTF-8";
    LC_IDENTIFICATION = "en_GB.UTF-8";
    LC_MEASUREMENT = "en_GB.UTF-8";
    LC_MONETARY = "en_GB.UTF-8";
    LC_NAME = "en_GB.UTF-8";
    LC_NUMERIC = "en_GB.UTF-8";
    LC_PAPER = "en_GB.UTF-8";
    LC_TELEPHONE = "en_GB.UTF-8";
    LC_TIME = "en_GB.UTF-8";
  };

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "gb";
    variant = "";
  };
  # Upgrade Nix OS
  system.autoUpgrade.enable = true;
  system.autoUpgrade.allowReboot = true;
  # Configure console keymap
  console.keyMap = "uk";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users."nix" = {
    isNormalUser = true;
    description = "Aidas";
    extraGroups = [ "networkmanager" "wheel"];
    shell = pkgs.zsh;
    packages = with pkgs; [
	kdePackages.kate
    ];
  };
nixpkgs.config.allowUnfree = true;
nixpkgs.config.permittedInsecurePackages = [
  "openssl-1.1.1w"   # the rebuild error will tell you the exact version string to use
];
# Install Thunderbird
  programs.thunderbird.enable = true;
# Install OBS
  programs.obs-studio.enable = true;

# Install VSCode
  programs.vscode.enable = true;

# Install Git
  programs.git.enable = true;

# Install Firefox.
  programs.firefox.enable = true;

# Install Zsh
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
    shellAliases = {
      ll = "ls -l";
      edit = "sudo -e";
      update = "sudo nixos-rebuild switch";
    };

    histFile = "$HOME/.zsh_history";
    setOptions = [
      "HIST_IGNORE_ALL_DUPS"
    ];
  };

  # Install Steam
  programs.steam = {
	enable = true;
	dedicatedServer.openFirewall = true;
  };
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  chessx
  obsidian
  wget
  openjdk
  steam
  steamcmd
  lm_sensors
  sublime4
  htop
  qemu_kvm
  zsh
  fastfetch
  discord
  lmstudio
  neovim
  mesa-demos
  inxi
  gcc
  tree-sitter
  busybox
];
  # Install libvirtd 
  virtualisation.libvirtd.enable = true;
  
  # Enable swtpm (TPM 2.0)
  virtualisation.libvirtd.qemu.swtpm.enable = true;

  # On host shutdown make sure guest OS are safely shutdown
  virtualisation.libvirtd.onShutdown = "suspend";
   
  programs.virt-manager.enable = true;
  users.groups.libvirtd.members = [ "nix" ];
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "26.05"; # Did you read the comment?

}

