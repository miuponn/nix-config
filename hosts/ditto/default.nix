# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, inputs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  # boot
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 20;
  boot.loader.efi.canTouchEfiVariables = true;

  # on boot failure, keep booting to support headless
  systemd.enableEmergencyMode = false;

  # filesystem mount options
  fileSystems."/".options = [ "compress=zstd" "noatime" ];
  fileSystems."/home".options = [ "compress=zstd" "noatime" ];
  fileSystems."/nix".options = [ "compress=zstd" "noatime" ];
  fileSystems."/var/log".options = [ "compress=zstd" "noatime" ];

  networking.hostName = "ditto";

  # Configure network connections interactively with nmcli or nmtui.
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Toronto";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_CA.UTF-8";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.kelly = {
     isNormalUser = true;
     extraGroups = [ "wheel" "networkmanager" ]; # Enable ‘sudo’ for the user.
     shell = pkgs.zsh;
     openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMV1ph3/e8BuYTfr/8VdUpoyOuY8RwDmX4WGAWv526Sr kelly@snorlax"
     ];
  };

  programs.zsh.enable = true;
  programs.vim = {
    enable = true;
    defaultEditor = true;
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    openFirewall = false;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  services.tailscale = {
    enable = true;
    openFirewall = true;
  };

  services.resolved.enable = true;

  networking.firewall = {
    enable = true;
    trustedInterfaces = [ "tailscale0" ];
  };

  # nix
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };
  nix.optimise.automatic = true;

  # packages + terminal support
  environment.enableAllTerminfo = true;
  environment.systemPackages = with pkgs; [ git htop ];

  system.stateVersion = "26.05";
  system.configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;
}

