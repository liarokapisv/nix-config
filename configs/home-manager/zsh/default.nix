{ config, lib, pkgs, ... }: {
  programs.zsh = {
    autosuggestion.enable = true;
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
    '' +
    lib.optionalString (config.programs.direnv.enable) ''
      # helper to change direnv devShells
      direnv-set () {
          local CONFIG_NAME="$1";
          local TARGET_ENVRC="''${2:-.envrc}";
          sed -i "s/\(use[[:space:]]\+flake[[:space:]]\+[^#]*\)\(#[[:space:]]*[^[:space:]]*\)\?/\1#$CONFIG_NAME/g" "$TARGET_ENVRC"
      }
    '';
  };
}
