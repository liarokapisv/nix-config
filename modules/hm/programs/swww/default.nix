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
      systemd =
        {
          enable = lib.mkEnableOption "swww systemd integration";
          targets =
            {
              PartOf = lib.mkOption {
                type = lib.types.listOf (lib.types.str);
                default = [ "graphical-session.target" ];
                description = ''
                  The systemd units that the swww service belongs to.
                  When setting this value make sure to also enable the appropriate units.
                '';
              };
              After = lib.mkOption {
                type = lib.types.listOf (lib.types.str);
                default = [ "graphical-session-pre.target" ];
                description = ''
                  The systemd units that must precede the swww service.
                  When setting this value make sure to also enable the appropriate units.
                '';
              };
              WantedBy = lib.mkOption {
                type = lib.types.listOf (lib.types.str);
                default = [ "graphical-session.target" ];
                description = ''
                  The systemd units that depend on the swww service.
                  When setting this value make sure to also enable the appropriate units.
                '';
              };
            };
          imgOptions = lib.mkOption {
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
                PartOf = cfg.systemd.targets.PartOf;
                After = cfg.systemd.targets.After;
              };

              Service = {
                ExecStart = "-${pkgs.swww}/bin/swww init --no-daemon";
                ExecStop = "${pkgs.swww}/bin/swww kill";
                Restart = "on-failure";
                RestartSec = 3;
                Environment = [
                  "PATH=${pkgs.swww}/bin"
                ];
              };

              Install = {
                WantedBy = cfg.systemd.targets.WantedBy;
              };
            };
          }

          (lib.mkIf
            (cfg.systemd.imgOptions != null)
            {
              systemd.user.services."swww.img" = {
                Unit = {
                  PartOf = "swww.service";
                  After = "swww.service";
                };

                Service = {
                  Type = "oneshot";
                  RemainAfterExit = "yes";
                  ExecStart = "${cfg.package}/bin/swww img ${cfg.systemd.imgOptions}";
                };
              };
            })
        ]))
      ]);
}



