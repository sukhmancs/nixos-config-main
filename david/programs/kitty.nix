{ vars, ... }:

{
  home-manager.users.${vars.user} = {
    home.file.".config/kitty" = {
      source = ./kitty;
      recursive = true;
    };
  };
}
