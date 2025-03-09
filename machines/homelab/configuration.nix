{ lib, ... }:
{
  imports = [
    ./user.nix

    ../../modules/system/base.nix
    ../../modules/system/environment.nix
    ../../modules/system/minimalise.nix
    ../../modules/system/nix.nix
    ../../modules/system/zfs.nix

    ../../modules/services/blacklist.nix
    ../../modules/services/dns.nix
    ../../modules/services/ssh.nix
    ../../modules/services/tailscale.nix

    ./services/alist.nix
    ./services/cockpit.nix
    ./services/code-server.nix
    ./services/dashy.nix
    ./services/forgejo.nix
    ./services/glances.nix
    ./services/gotify.nix
    ./services/immich.nix
    ./services/nginx.nix
    ./services/postgres.nix
    ./services/power-management.nix
    ./services/restic.nix
    ./services/samba.nix
    ./services/syncthing.nix
    ./services/wakapi.nix
  ] ++ lib.filesystem.listFilesRecursive ../../modules/options;
  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
  };

  # Enable networking
  networking = {
    hostName = "homelab";
  };

  clan.core.networking.targetHost = "root@homelab";

}
