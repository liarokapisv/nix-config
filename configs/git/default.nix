{
  flake.modules.homeManager.config-git =
    { pkgs, ... }:
    {
      programs.git = {

        settings = {
          init = {
            defaultBranch = "main";
          };
          user = {
            name = "Alexandros Liarokapis";
            email = "liarokapis.v@gmail.com";
          };
          fetch = {
            prune = true;
          };
          push = {
            autoSetupRemote = true;
          };
          diff = {
            tool = "vimdiff";
          };
          difftool = {
            prompt = false;
          };
          http = {
            postBuffer = 52428800;
          };
          alias = {
            prune-gone =
              let
                awk = "${pkgs.gawk}/bin/awk";
                xargs = "${pkgs.findutils}/bin/xargs";
              in
              ''
                !git fetch --prune &&
                git for-each-ref --format="%(refname:short) %(upstream:track)" refs/heads |
                ${awk} '$2=="[gone]" {print $1}' |
                ${xargs} -r git branch -D
              '';
          };
        };
        ignores = [
          "result*"
          ".envrc"
          ".direnv"
        ];
      };
    };
}
