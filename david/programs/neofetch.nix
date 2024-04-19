{ vars, ... }:

{
  home-manager.users.${vars.user} = {
    home.file.".config/neofetch" = {
      source = ./neofetch;
      recursive = true;
    };
  };
}
