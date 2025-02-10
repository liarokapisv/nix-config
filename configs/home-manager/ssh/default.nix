{
  programs = {
    ssh = {
      extraConfig = builtins.readFile ./config;
    };
  };
}
