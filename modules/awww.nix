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
                      # Back off instead of hammering: a transient failure must not
                      # burn the start limit and leave the wallpaper unset.
                      StartLimitIntervalSec = 60;
                      StartLimitBurst = 5;
                    };

                    Service = {
                      Type = "oneshot";
                      Restart = "on-failure";
                      RestartSec = 2;
                      # Wait until the daemon actually answers before running
                      # `awww img`. The old bare `sleep 1` could race a not-yet-ready
                      # daemon; `awww img` would then abort mid-write and leave a
                      # truncated 0-byte cache file, which makes every later run
                      # mmap(len=0) -> EINVAL panic (common/src/mmap.rs) permanently.
                      ExecStartPre = "${pkgs.bash}/bin/bash -c 'for i in $(${pkgs.coreutils}/bin/seq 1 30); do ${cfg.package}/bin/awww query >/dev/null 2>&1 && exit 0; ${pkgs.coreutils}/bin/sleep 1; done; exit 1'";
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
