{
  flake.modules.homeManager.awww =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      options = {
        programs.awww = {
          enable = lib.mkEnableOption "awww";
          package = lib.mkOption {
            type = lib.types.package;
            default = pkgs.awww;
            defaultText = lib.literalExpression "pkgs.awww";
            description = ''
              Swww package to use. Set to `null` to use the default package.
            '';
          };
          systemd = {
            enable = lib.mkOption {
              type = lib.types.bool;
              default = true;
              example = "true";
              description = "Whether to enable awww systemd integration.";
            };

            target = lib.mkOption {
              type = lib.types.str;
              default = "graphical-session.target";
              description = ''
                The systemd units that the awww service belongs to.
                When setting this value make sure to also enable the appropriate units.
              '';
            };

            exec-img = lib.mkOption {
              type = lib.types.str;
              example = "<path/to/img> -o <output> --transition-step <1 to 255> --transition-fps <1 to 255>";
              description = ''
                The options of the optional awww img cmd to run after the awww service is started.
              '';
            };
          };
        };
      };

      config =
        let
          cfg = config.programs.awww;
        in
        lib.mkIf (cfg.enable) (
          lib.mkMerge [
            { home.packages = [ pkgs.awww ]; }

            (lib.mkIf (cfg.systemd.enable) (
              lib.mkMerge [
                {
                  systemd.user.services.awww = {
                    Unit = {
                      PartOf = [ cfg.systemd.target ];
                      After = [ cfg.systemd.target ];
                    };

                    Service = {
                      ExecStart = "-${pkgs.awww}/bin/awww-daemon -q";
                      ExecStop = "${pkgs.awww}/bin/awww kill";
                      Restart = "on-failure";
                      RestartSec = 3;
                      Environment = [ "PATH=${pkgs.awww}/bin" ];
                    };

                    Install = {
                      WantedBy = [ cfg.systemd.target ];
                    };
                  };
                }

                (lib.mkIf (cfg.systemd.exec-img != null) {
                  systemd.user.services."awww.img" = {
                    Unit = {
                      PartOf = [ "awww.service" ];
                      After = [ "awww.service" ];
                    };

                    Service = {
                      Type = "oneshot";
                      Restart = "on-failure";
                      ExecStartPre = "${pkgs.coreutils}/bin/sleep 1";
                      ExecStart = "${cfg.package}/bin/awww img ${cfg.systemd.exec-img}";
                    };

                    Install = {
                      WantedBy = [ "awww.service" ];
                    };
                  };
                })
              ]
            ))
          ]
        );
    };
}
