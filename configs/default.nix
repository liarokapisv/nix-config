{ self, ... }:
{
  flake.modules.homeManager.configs = {
    imports = [
      self.modules.homeManager.config-direnv
      self.modules.homeManager.config-git
      self.modules.homeManager.config-zathura
      self.modules.homeManager.config-kitty
      self.modules.homeManager.config-ssh
      self.modules.homeManager.config-niri
      self.modules.homeManager.config-tmux
      self.modules.homeManager.config-neovim
      self.modules.homeManager.config-firefox
      self.modules.homeManager.config-zsh
      self.modules.homeManager.config-dms
    ];
  };
}
