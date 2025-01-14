{
  services = {
    upower.enable = true;

    logind = {
      powerKey = "suspend-then-hibernate";
      lidSwitch = "suspend-then-hibernate";
    };
  };

  systemd.sleep.extraConfig = ''
    HibernateDelaySec=45m
  '';
}
