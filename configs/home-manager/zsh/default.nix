{ pkgs, ... }:
{
  programs.zsh = {
    autosuggestion.enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;

    autocd = true;

    plugins = [
      {
        name = "zsh-completion-sync";
        src = "${pkgs.zsh-completion-sync}/share/zsh-completion-sync";
      }
      {
        name = "zsh-history-substring-search";
        src = "${pkgs.zsh-history-substring-search}/share/zsh-history-substring-search";
        file = "zsh-history-substring-search.zsh";
      }
    ];

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

    initContent = ''
      bindkey '^F' autosuggest-accept
      bindkey -M viins "\e." insert-last-word

      bindkey -M vicmd "k" history-substring-search-up
      bindkey -M vicmd "j" history-substring-search-down
    '';
  };
}
