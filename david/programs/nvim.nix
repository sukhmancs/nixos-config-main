#
# Nixvim
#
{
  inputs,
  system,
  ...
}: {
  environment.systemPackages = [inputs.nixvim-flake.packages.${system}.default];
}
