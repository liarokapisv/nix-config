{
  flake.modules.homeManager.config-zsh =
    { config, pkgs, ... }:
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
          # fix highlight issues on autosuggest acceptance
          ZSH_AUTOSUGGEST_CLEAR_WIDGETS+=(accept-line yank kill-whole-line vi-accept-line)
          autosuggest_accept_and_clear() {
            zle autosuggest-accept
            region_highlight=()
            zle reset-prompt
          }
          ZSH_AUTOSUGGEST_ACCEPT_WIDGETS+=(autosuggest_accept_and_clear)
          zle -N autosuggest_accept_and_clear

          bindkey '^F' autosuggest_accept_and_clear

          bindkey -M viins "\e." insert-last-word
          bindkey -M vicmd "k" history-substring-search-up
          bindkey -M vicmd "j" history-substring-search-down

          alias git-log-oneline="git log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) -%C(auto)%d%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)' --all"

        '';
      };
    };
}
