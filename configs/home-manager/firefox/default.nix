{ self, config, lib, pkgs, ... }: {

  config = lib.mkMerge [
    ({
      programs.firefox.profiles.default = {
        search = {
          default = "Google";
          engines = {
            "Nix Packages" = {
              urls = [{
                template = "https://search.nixos.org/packages";
                params = [
                  {
                    name = "channel";
                    value = "unstable";
                  }
                  {
                    name = "type";
                    value = "packages";
                  }
                  {
                    name = "query";
                    value = "{searchTerms}";
                  }
                ];
              }];

              icon =
                "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nx-snowflake.svg";
              definedAliases = [ "@np" ];
            };

            "Nixos Options" = {
              urls = [{
                template = "https://search.nixos.org/options";
                params = [
                  {
                    name = "channel";
                    value = "unstable";
                  }
                  {
                    name = "type";
                    value = "packages";
                  }
                  {
                    name = "query";
                    value = "{searchTerms}";
                  }
                ];
              }];

              icon =
                "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = [ "@no" ];
            };

            "Home Manager Options" = {
              urls = [{
                template = "https://home-manager-options.extranix.com";
                params = [
                  {
                    name = "query";
                    value = "{searchTerms}";
                  }
                  {
                    name = "release";
                    value = "master";
                  }
                ];
              }];

              icon =
                "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = [ "@hm" ];
            };

            "NixOS Wiki" = {
              urls = [{
                template = "https://nixos.wiki/index.php?search={searchTerms}";
              }];
              iconUpdateURL = "https://nixos.wiki/favicon.png";
              updateInterval = 24 * 60 * 60 * 1000; # every day
              definedAliases = [ "@nw" ];
            };

            "Bing".metaData.hidden = true;
            "Google".metaData.alias =
              "@g"; # builtin engines only support specifying one additional alias
          };
          force = true;
        };

        extensions = let
          addons =
            self.inputs.firefox-addons.packages.${pkgs.hostPlatform.system};
          sameStdenv = addon: addon.override { inherit (pkgs) stdenv; };
        in builtins.map sameStdenv (with addons; [
          ublock-origin
          bitwarden
          i-dont-care-about-cookies
          vimium
          languagetool
          user-agent-string-switcher
        ]);

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
                    url =
                      "https://mipmip.github.io/home-manager-option-search/";
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
          # Enable toolbar by default
          "browser.toolbars.bookmarks.visibility" = "always";
          # We use bitwarden, disable embedded password manager
          "signon.rememberSignons" = false;
          "signon.autofillForms" = false;
          "signon.passwordEditCapture.enabled" = false;
          "services.sync.engine.passwords" = false;
          "browser.urlbar.showSearchSuggestionsFirst" = false;
        };
      };
    })

    (lib.mkIf pkgs.stdenv.hostPlatform.isAarch64 {

      programs.firefox.profiles.default.settings = {
        "media.gmp-widevinecdm.version" = pkgs.widevinecdm-aarch64.version;
        "media.gmp-widevinecdm.visible" = true;
        "media.gmp-widevinecdm.enabled" = true;
        "media.gmp-widevinecdm.autoupdate" = false;
        "media.eme.enabled" = true;
        "media.eme.encrypted-media-encryption-scheme.enabled" = true;
      };

      home.file."firefox-widevinecdm" = {
        enable = true;
        target = ".mozilla/firefox/default/gmp-widevinecdm";
        source = pkgs.runCommandLocal "firefox-widevinecdm" { } ''
          out=$out/${pkgs.widevinecdm-aarch64.version}
          mkdir -p $out
          ln -s ${pkgs.widevinecdm-aarch64}/manifest.json $out/manifest.json
          ln -s ${pkgs.widevinecdm-aarch64}/libwidevinecdm.so $out/libwidevinecdm.so
        '';
        recursive = true;
      };
    })
  ];
}
