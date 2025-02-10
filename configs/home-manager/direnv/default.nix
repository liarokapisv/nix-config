{
  programs.direnv = {
    enableBashIntegration = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
    config = {
      global = {
        warn_timeout = "1000h";
        load_dotenv = true;
      };
    };
  };
}
