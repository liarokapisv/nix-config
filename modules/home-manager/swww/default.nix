{ config, lib, pkgs, ... }: {
  options = {
    programs.swww = {
      enable = lib.mkEnableOption "swww";
      package = lib.mkOption {
        type = lib.types.package;
        default = pkgs.swww;
        defaultText = lib.literalExpression "pkgs.swww";
        description = ''
          Swww package to use. Set to `null` to use the default package.
        '';
      };
      systemd = {
        enable = lib.mkOption {
          type = lib.types.bool;
          default = true;
          example = "true";
          description = "Whether to enable swww systemd integration.";
        };

        target = lib.mkOption {
          type = lib.types.str;
          default = "graphical-session.target";
          description = ''
            The systemd units that the swww service belongs to.
            When setting this value make sure to also enable the appropriate units.
          '';
        };

        exec-img = lib.mkOption {
          type = lib.types.str;
          example = "<path/to/img> -o <output> --transition-step <1 to 255> --transition-fps <1 to 255>";
          description = ''
            The options of the optional swww img cmd to run after the swww service is started.
          '';
        };
      };
    };
  };

  config =
    let
      cfg = config.programs.swww;
    in
    lib.mkIf (cfg.enable)
      (lib.mkMerge [
        {
          home.packages = [
            pkgs.swww
          ];
        }

        (lib.mkIf (cfg.systemd.enable) (lib.mkMerge [
          {
            systemd.user.services.swww = {
              Unit = {
                PartOf = [ cfg.systemd.target ];
                After = [ cfg.systemd.target ];
              };

              Service = {
                ExecStart = "-${pkgs.swww}/bin/swww-daemon";
                ExecStop = "${pkgs.swww}/bin/swww kill";
                Restart = "on-failure";
                RestartSec = 3;
                Environment = [
                  "PATH=${pkgs.swww}/bin"
                ];
              };

              Install = {
                WantedBy = [ cfg.systemd.target ];
              };
            };
          }

          (lib.mkIf
            (cfg.systemd.exec-img != null)
            {
              systemd.user.services."swww.img" = {
                Unit = {
                  PartOf = [ "swww.service" ];
                  After = [ "swww.service" ];
                };

                Service = {
                  Type = "oneshot";
                  Restart = "on-failure";
                  ExecStartPre = "${pkgs.coreutils}/bin/sleep 1";
                  ExecStart = "${cfg.package}/bin/swww img ${cfg.systemd.exec-img}";
                };

                Install = {
                  WantedBy = [ "swww.service" ];
                };
              };
            })
        ]))
      ]);
}



