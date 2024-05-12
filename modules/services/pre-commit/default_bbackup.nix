let
  nix-pre-commit-hooks = import (builtins.fetchTarball "https://github.com/cachix/pre-commit-hooks.nix/tarball/master");
in {
  # Configured with the module options defined in `modules/pre-commit.nix`:
  pre-commit-check = nix-pre-commit-hooks.run {
    src = ./.;
    # If your hooks are intrusive, avoid running on each commit with a default_states like this:
    # default_stages = ["manual" "push"];
    hooks = {
      elm-format.enable = true;

      # override a package with a different version
      ormolu.enable = true;
      ormolu.settings.defaultExtensions = ["lhs" "hs"];
    };
  };
}
