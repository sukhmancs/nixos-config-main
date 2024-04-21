#
# Nixvim
#

{ inputs, system, ... }:

{
  environment.systemPackages = [ inputs.nixvim.packages.${system}.default ];
}
