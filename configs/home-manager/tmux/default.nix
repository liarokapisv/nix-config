{ pkgs, ... }: {
  programs.tmux = {
    mouse = true;
    keyMode = "vi";
    plugins = with pkgs; [
      tmuxPlugins.vim-tmux-navigator
      (tmuxPlugins.resurrect.overrideAttrs (old: {
        # TODO: Remove when fixed upstream.
        dontCheckForBrokenSymlinks = true;
      }))
      (tmuxPlugins.mkTmuxPlugin {
        pluginName = "named-snapshot";
        rtpFilePath = "named-snapshot.tmux";
        version = "872fede";
        src = fetchFromGitHub {
          owner = "spywhere";
          repo = "tmux-named-snapshot";
          rev = "872fedef62c1b732a56ca643f2354346912e06c3";
          hash = "sha256-EW1X+ZVl+hIIqAsj+bv6dkjQtNiBEhUYOQK/8bFEpV8=";
        };
      })
    ];
    extraConfig = ''
      bind | split-window -hc "#{pane_current_path}"
      bind - split-window -vc "#{pane_current_path}"
      bind -r S-h swap-window -d -t -1
      bind -r S-l swap-window -d -t +1
    '';
  };
}
