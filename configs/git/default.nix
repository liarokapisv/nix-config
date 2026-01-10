{
  flake.modules.homeManager.config-git = {
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
      };
      ignores = [
        "result*"
        ".envrc"
        ".direnv"
      ];
    };
  };
}
