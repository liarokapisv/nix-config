{
  programs.direnv = {
    enableZshIntegration = true;
    nix-direnv.enable = true;
    config = {
      warn_timeout = "1000h";
    };
  };
}
