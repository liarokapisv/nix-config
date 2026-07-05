{
  flake.modules.nixos.printing = { pkgs, ... }: {
    services.avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };

    services.printing = {
      enable = true;
      drivers = with pkgs; [
        cups-filters
      ];
      # Disable cups-browsed: buggy in 2.1.1 — it auto-creates broken implicitclass://
      # queues that fail at print time with "No destination host name supplied by
      # cups-browsed", causing CUPS to pause the queue. It defaults to on whenever
      # avahi is enabled. CUPS 2.4 + cups-filters do driverless DNS-SD auto-discovery
      # on their own (temporary queues on demand), so browsed is not needed.
      browsed.enable = false;
    };
  };
}
