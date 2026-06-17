{
  flake.modules.nixos.power = {
    services = {
      upower = {
        enable = true;

        # UPower only performs CriticalPowerAction itself at percentageAction;
        # raise it from the 2% default so the machine saves state before it is
        # nearly dead (requires low > critical > action).
        percentageLow = 20;
        percentageCritical = 8;
        percentageAction = 5;
      };

      logind.settings = {
        Login.HandlePowerKey = "suspend-then-hibernate";
        Login.HandleLidSwitch = "suspend-then-hibernate";
      };
    };

    systemd.sleep.settings.Sleep = {
      HibernateDelaySec = 2700;
    };
  };

  # User-side low-battery alerting. The dankBatteryAlerts plugin (defaults:
  # warning 20%, critical 10%) sends alerts by shelling out to notify-send, so
  # libnotify must be on PATH. Gated on niri/DMS, matching configs/dms.
  flake.modules.homeManager.power =
    {
      pkgs,
      lib,
      osConfig,
      ...
    }:
    lib.mkIf (osConfig.programs.niri.enable or false) {
      home.packages = [ pkgs.libnotify ];
      programs.dank-material-shell.plugins.dankBatteryAlerts.enable = true;
    };
}
