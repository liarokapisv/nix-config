{
  flake.modules.homeManager.config-zathura = {
    programs.zathura = {
      extraConfig = ''
        map u scroll half-up
        map d scroll half-down
        map <Space> navigate next
        map <S-Space> navigate previous
      '';
    };
  };
}
