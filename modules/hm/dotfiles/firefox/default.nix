{ self, config, pkgs, lib, ... }: {

  imports = [
    self.inputs.nur.hmModules.nur
  ];

  config = lib.mkIf config.programs.firefox.enable {

    programs.firefox.profiles.default =
      {
        search = {
          default = "Google";
          engines =
            {
              "Nix Packages" = {
                urls = [{
                  template = "https://search.nixos.org/packages";
                  params = [
                    { name = "channel"; value = "unstable"; }
                    { name = "type"; value = "packages"; }
                    { name = "query"; value = "{searchTerms}"; }
                  ];
                }];

                icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nx-snowflake.svg";
                definedAliases = [ "@np" ];
              };

              "Nixos Options" = {
                urls = [{
                  template = "https://search.nixos.org/options";
                  params = [
                    { name = "channel"; value = "unstable"; }
                    { name = "type"; value = "packages"; }
                    { name = "query"; value = "{searchTerms}"; }
                  ];
                }];

                icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
                definedAliases = [ "@no" ];
              };

              "Home Manager Options" = {
                urls = [{
                  template = "https://mipmip.github.io/home-manager-option-search";
                  params = [
                    { name = "query"; value = "{searchTerms}"; }
                  ];
                }];

                icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
                definedAliases = [ "@hm" ];
              };

              "NixOS Wiki" = {
                urls = [{ template = "https://nixos.wiki/index.php?search={searchTerms}"; }];
                iconUpdateURL = "https://nixos.wiki/favicon.png";
                updateInterval = 24 * 60 * 60 * 1000; # every day
                definedAliases = [ "@nw" ];
              };

              "Bing".metaData.hidden = true;
              "Google".metaData.alias = "@g"; # builtin engines only support specifying one additional alias
            };
          force = true;
        };

        extensions = with config.nur.repos.rycee.firefox-addons; [
          ublock-origin
          bitwarden
          i-dont-care-about-cookies
          vimium
          languagetool
        ];

        bookmarks = [
          {
            toolbar = true;
            bookmarks = [
              {
                name = "Ricing";
                bookmarks = [
                  {
                    name = "eww";
                    url = "https://github.com/elkowar/eww";
                  }
                  {
                    name = "swww";
                    url = "https://github.com/Horus645/swww";
                  }
                  {
                    name = "Waybar";
                    url = "https://github.com/Alexays/Waybar";
                  }
                  {
                    name = "Fuzzel";
                    url = "https://codeberg.org/dnkl/fuzzel";
                  }
                  {
                    name = "Firefox twily-theme";
                    url = "https://twily.info/firefox/stylish/firefox-css";
                  }
                  {
                    name = "PROxZIMA dotfiles";
                    url = "https://github.com/PROxZIMA/.dotfiles/";
                  }
                  {
                    name = "i4pg dotfiles";
                    url = "https://github.com/i4pg/dotfiles/tree/main";
                  }
                  {
                    name = "Stylix";
                    url = "https://github.com/danth/stylix";
                  }
                ];
              }
              {
                name = "Nix sites";
                bookmarks = [
                  {
                    name = "home manager search";
                    url = "https://mipmip.github.io/home-manager-option-search/";
                  }
                  {
                    name = "nixos search";
                    url = "https://search.nixos.org/packages";
                  }
                  {
                    name = "homepage";
                    url = "https://nixos.org/";
                  }
                  {
                    name = "wiki";
                    tags = [ "wiki" "nix" ];
                    url = "https://nixos.wiki/";
                  }
                ];
              }
            ];
          }
          {
            # Used to be able to escape to unfocus from url bar due to firefox restriction.
            name = "Unfocus hack";
            keyword = "j";
            url = "javascript:()";
          }
        ];

        settings = {
          # Disable annoying pocket plugin
          "extensions.pocket.enabled" = false;
          # We use bitwarden, disable embedded password manager
          "signon.rememberSignons" = true;
          # Enable toolbar by default
          "browser.toolbars.bookmarks.visibility" = "always";
        };
      };

  };
}
