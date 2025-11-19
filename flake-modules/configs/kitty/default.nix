{
  flake.modules.homeManager.config-kitty = {
    programs.kitty = {
      settings = {
        enable_audio_bell = false;
      };
    };
  };
}
