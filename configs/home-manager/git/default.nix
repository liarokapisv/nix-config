{
  programs.git = {
    extraConfig = {
      init = { defaultBranch = "main"; };
      user = {
        name = "Alexandros Liarokapis";
        email = "liarokapis.v@gmail.com";
      };
      diff = { tool = "vimdiff"; };
      difftool = { prompt = false; };
      http = { postBuffer = 52428800; };
    };
    ignores = [ "result" ".envrc" ".direnv" ];
  };
}
