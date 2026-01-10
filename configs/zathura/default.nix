{
  flake.modules.homeManager.config-zathura = {
    programs.zathura = {
      mappings = {
        "u" = "scroll half-up";
        "d" = "scroll half-down";
        "<Space>" = "navigate next";
        "<S-Space>" = "navigate previous";
      };
      options = {
        "selection-clipboard" = "clipboard";
      };
    };
  };
}
