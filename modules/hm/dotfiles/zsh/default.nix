{ config, lib, pkgs, ... }: {

  options = {
    dotfiles.zsh.enable = lib.mkEnableOption "zsh";
  };

  config = lib.mkIf (config.dotfiles.zsh.enable) {
    programs = {
      zsh = {
        enable = true;
        enableAutosuggestions = true;
        enableCompletion = true;
        syntaxHighlighting.enable = true;

        autocd = true;

        oh-my-zsh = {
          enable = true;
          plugins = [
            "git"
            "fzf"
            "vi-mode"
          ];

          theme = "robbyrussell";
        };

        # Manually sourcing zsh-history-substring-search instead of using the program option due to
        # not being able to supply -M to bindkey with the stock option.
        # See: https://github.com/nix-community/home-manager/issues/4264

        initExtra = ''
          bindkey '^F' autosuggest-accept
          bindkey -M viins "\e." insert-last-word

          source ${pkgs.zsh-history-substring-search}/share/zsh-history-substring-search/zsh-history-substring-search.zsh
          bindkey -M vicmd "k" history-substring-search-up
          bindkey -M vicmd "j" history-substring-search-down
        '';
      };
    };
  };
}