{
  home = {
    username = "sas";
    homeDirectory = "/home/sas";
    stateVersion = "23.11";
  };
  programs = {
    git = {
      enable = true;
      userName = "ukizet";
      userEmail = "ukikatuki@gmail.com";
    };
    bash = {
      enable = true;
      shellAliases = {
        rebuild = "sudo nixos-rebuild switch --flake ~/mysystem/";
        upgraderebuild = "
          cd ~/mysystem/ &&
          nix flake update &&
          sudo nixos-rebuild switch --update --flake .
        ";
        nixclean = "
          sudo nix-collect-garbage -d &&
          nix-collect-garbage -d &&
          sudo nix-store --optimise &&
          sudo nix-store --gc
        ";
        gs = "git status";
        gcam = "git commit -am";
        gpush = "git push";
        gpull = "git pull";
        gad = "git add .";
        scmd = "steamcmd";
      };
    };
  };
}
