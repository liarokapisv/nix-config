{ self, ... }:
let
  config = user: {
    modules = [
      (
        { pkgs, ... }:
        {
          targets.genericLinux.enable = true;

          stylix = {
            image = "${self.outPath}/images/mountain-music.gif";
            targets.kde.enable = false;
          };

          home = {
            packages = with pkgs; [
              spotify
              discord
              viber
              eagle
              anydesk
              slack
              discord
              teams-for-linux
              zoom-us
              xclip
            ];

            username = user;
            homeDirectory = "/home/${user}";

            stateVersion = "24.11";
          };
        }
      )
    ];
  };
in
{
  home-configurations."alexandros-liarokapis@acumino" = config "alexandros-liarokapis";
  home-configurations."alex@acumino" = config "alex";
}
