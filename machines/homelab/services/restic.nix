{ pkgs, config, ... }:
{
  services.restic = {
    backups = {
      local = {
        initialize = true;
        passwordFile = config.sops.secrets.homelab-restic-local-password.path;
        paths = [
          "/var/lib/alist"
          "/var/lib/forgejo"
          "/var/lib/homebox"
          "/var/lib/jellyfin"
          "/var/lib/postgresql"
          "/var/lib/wakapi"
        ];
        repository = "/backup/restic";
        timerConfig = {
          OnCalendar = "21:00:00";
          Persistent = true;
        };
        backupPrepareCommand = ''
          ${pkgs.curl}/bin/curl "http://127.0.0.1:1245/message?token=AkFEQLUQdbIP7yG" \
            -F "title=restic local backup start" \
            -F "message=$(date "+%H:%M:%S")" \
            -F "priority=2"
        '';
        backupCleanupCommand = ''
          ${pkgs.curl}/bin/curl "http://127.0.0.1:1245/message?token=AkFEQLUQdbIP7yG" \
            -F "title=restic local logs" \
            -F "message=$(journalctl -u restic-backups-local.service --since '10 minute ago' -o cat) | over." \
            -F "priority=1"
        '';
      };
      remote1 = {
        initialize = true;
        passwordFile = config.sops.secrets.homelab-restic-remote1-password.path;
        environmentFile = config.sops.secrets.homelab-restic-remote1-environment.path;
        paths = [
          "/var/lib/alist"
          "/var/lib/forgejo"
          "/var/lib/homebox"
          "/var/lib/jellyfin"
          "/var/lib/postgresql"
          "/var/lib/wakapi"
        ];
        repositoryFile = config.sops.secrets.homelab-restic-remote1-repository.path;
        timerConfig = {
          OnCalendar = "21:10:00";
          Persistent = true;
        };
        backupPrepareCommand = ''
          ${pkgs.curl}/bin/curl "http://127.0.0.1:1245/message?token=AkFEQLUQdbIP7yG" \
            -F "title=restic remote1 backup start" \
            -F "message=$(date "+%H:%M:%S")" \
            -F "priority=2"
        '';
        backupCleanupCommand = ''
          ${pkgs.curl}/bin/curl "http://127.0.0.1:1245/message?token=AkFEQLUQdbIP7yG" \
            -F "title=restic remote1 logs" \
            -F "message=$(journalctl -u restic-backups-remote1.service --since '10 minute ago' -o cat) | over." \
            -F "priority=1"
        '';
      };
    };
  };
}
