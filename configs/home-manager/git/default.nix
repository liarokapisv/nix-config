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
      http = {
        postBuffer = 52428800;
      };
    };
  };
}
