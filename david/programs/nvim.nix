#
# Nixvim
#

{ inputs, system, ... }:

{
  environment.systemPackages = [ inputs.nvim.packages.${system}.default ];
}
