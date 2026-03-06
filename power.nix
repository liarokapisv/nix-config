{
  flake.modules.nixos.power = {
    services = {
      upower.enable = true;

      logind.settings = {
        Login.HandlePowerKey = "suspend-then-hibernate";
        Login.HandleLidSwitch = "suspend-then-hibernate";
      };
    };

    systemd.sleep.settings.Sleep = {
      HibernateDelaySec = 2700;
    };
  };
}
