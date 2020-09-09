{ config, lib, pkgs, ... }:

with lib;


let
  digitalOceanTarget = true;
  additionalImports = (if digitalOceanTarget then [ <nixpkgs/nixos/modules/virtualisation/digital-ocean-config.nix> ] else []);
in
{

  fileSystems."/".device = "/dev/disk/by-label/nixos";
  fileSystems."/".autoResize = true;
  fileSystems."/".fsType = "ext4";
  boot.loader.grub.device = "/dev/vda";
  boot.loader.timeout = 0;
  boot.kernelParams = [ "mitigations=off" "console=ttyS0" ];
  boot.growPartition = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.initrd.availableKernelModules = [ "virtio_net" "virtio_pci" "virtio_mmio" "virtio_blk" "virtio_scsi" "9p" "9pnet_virtio" ];
  boot.initrd.kernelModules = [ "virtio_balloon" "virtio_console" "virtio_rng" ];


  imports = additionalImports;
  
  i18n.supportedLocales = [ (config.i18n.defaultLocale + "/UTF-8") ];

  users.mutableUsers = true;

  networking.firewall.interfaces.eth0.allowedTCPPorts = [ 22 ];

  networking.dhcpcd.enable = true;
  
  environment.systemPackages = with pkgs; [
    git tmux zsh mosh dstat vim strace ltrace curl mosh
  ];


  environment.variables = {
    EDITOR = "vim";
  };

  programs.zsh.enable = true;

  security.sudo.wheelNeedsPassword = false;

  security.sudo.enable = true;

  networking.usePredictableInterfaceNames = false;

  services.sshd.enable = true;

  nixpkgs.config.allowUnfree = true;

  time.timeZone = "UTC";
  
}
