#
# Yet another nix helper
#
{
  programs.nh = {
    enable = true;
    clean = {
      enable = true;
      dates = "daily";
    };
  };
}
