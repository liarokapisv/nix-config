{ self, ... }:
{
  # Local dev-env flake (git+file until pushed to a remote). A git+file input
  # reads the repo's committed HEAD, so changes there must be committed to take
  # effect here.
  flake-file.inputs.acubrain-dev-env.url = "git+file:///home/veritas/development/acumino/dev-env";

  # NixOS feature module: trust the AcuBrain local dev CA and map the dev
  # hostnames to loopback. The upstream module carries its own `enable` toggle.
  flake.modules.nixos.acubrain-dev = {
    imports = [
      self.inputs.acubrain-dev-env.nixosModules.acubrain-dev
    ];

    acubrain-dev = {
      enable = true;
      caCertFile = ./configs/acubrain-dev-ca.pem;
    };
  };
}
