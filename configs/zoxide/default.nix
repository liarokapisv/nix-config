{
  flake.modules.homeManager.config-zoxide = { lib, ... }: {
    programs.zoxide = {
      enable = true;
      enableZshIntegration = true;
      enableBashIntegration = true;
      options = [
        "--cmd cd"
      ];
    };

    # Claude Code runs every command through a captured zsh snapshot that replays
    # zoxide's `cd` override but not its chpwd hook, so zoxide's doctor warns on
    # every `cd <dir> && ...` agent command. The snapshot is generated with
    # CLAUDECODE=1 set, so drop the override there: agents get the real builtin cd
    # (silences the doctor, avoids fuzzy-match surprises). Interactive shells keep
    # cd = zoxide.
    programs.zsh.initContent = lib.mkAfter ''
      if [[ -n "$CLAUDECODE" ]]; then
        unfunction cd 2>/dev/null || true
      fi
    '';
  };
}
