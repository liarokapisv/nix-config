{ self, pkgs, ... }: {

  imports = [
    self.inputs.home-manager.nixosModules.home-manager
  ];

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
  };

  nixpkgs.config.allowUnfree = true;

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit self; };
  };

  networking.useDHCP = false;

  users.mutableUsers = false;

  programs = {
    zsh.enable = true;
    neovim = {
      enable = true;
      defaultEditor = true;
    };
    fuse.userAllowOther = true;
  };

  environment.systemPackages = with pkgs; [
    wget
  ];
}
