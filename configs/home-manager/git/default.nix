{
  programs.git = {
    extraConfig = {
      init = {
        defaultBranch = "main";
      };
      user = {
        name = "Alexandros Liarokapis";
        email = "liarokapis.v@gmail.com";
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
}
