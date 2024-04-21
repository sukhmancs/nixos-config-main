#
# Nixvim
#
{
  inputs,
  system,
  ...
}: {
  environment.systemPackages = [inputs.vim.packages.${system}.default];
}
