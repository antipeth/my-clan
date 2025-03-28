{ lib, pkgs, ... }:
let
  inherit (import ../env.nix) TV_MODE;
in
# kodi-gbm = pkgs.kodi-gbm.withPackages (
#   kodiPackages: with kodiPackages; [
#     jellyfin
#   ]
# );
lib.mkIf TV_MODE {
  services.xserver.enable = true;
  services.xserver.desktopManager.kodi.enable = true;
  services.xserver.desktopManager.kodi.package = pkgs.kodi.withPackages (
    pkgs: with pkgs; [
      jellycon
    ]
  );
  services.displayManager.autoLogin.user = "kodi";

  services.xserver.displayManager.lightdm.greeter.enable = false;

  # Define a user account
  users.extraUsers.kodi.isNormalUser = true;

  xdg = {
    autostart.enable = true;
    icons.enable = true;
    menus.enable = true;
    mime.enable = true;
    sounds.enable = true;
  };
  systemd = {
    services = {
      systemd-user-sessions.enable = true;
    };
  };

}
