{
  flake.modules.homeManager.config-kitty = {
    programs.kitty = {
      settings = {
        enable_audio_bell = false;
        auto_reload_config = "-1";
      };
    };
  };
}
