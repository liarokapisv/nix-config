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
    ignores = [
      "result"
      "result-bin"
      "result-debug"
      "result-dev"
      "result-devdoc"
      "result-lib"
      "result-man"
      "result-out"
      ".envrc"
      ".direnv"
    ];
  };
}
