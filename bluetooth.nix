{ self, ... }:
{
  flake.modules.nixos.bluetooth = {
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = false;
    };

    services.blueman.enable = true;
  };

  flake.modules.homeManager.bluetooth =
    { pkgs, lib, ... }:
    {
      services.blueman-applet.enable = true;
      # TODO: remove once fixed upstream in home-manager.
      # The blueman-applet module generates both a base unit and a drop-in
      # override, both setting ExecStart. Systemd rejects duplicate ExecStart
      # for non-oneshot services. Remove ExecStart from the drop-in since the
      # base unit already has it.
      systemd.user.services.blueman-applet.Service.ExecStart = lib.mkForce [ ];
    };
}
