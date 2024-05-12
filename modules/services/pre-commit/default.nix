#
# pre-commit-hooks for nix
#
let
  nix-pre-commit-hooks = import (builtins.fetchTarball {
    url = "https://github.com/cachix/pre-commit-hooks.nix/tarball/master";
    sha256 = "sha256:0ag90l0hrkhm02mkmm8yf3fnjjawv99czc7bp0szzgknps0xrzxb";
  });
  # don't format these
  # excludes = ["flake.lock" "r'.+\.age$'"];
in {
  pre-commit-check = nix-pre-commit-hooks.run {
    src = ./.;
    # settings = {
    #   inherit excludes;
    #
    hooks = {
      alejandra = {
        enable = true;
        description = "pre commit hook for Alejandra";
        fail_fast = true;
        verbose = true;
      };
      actionlint = {
        enable = true;
        description = "pre commit hook for actionlint";
        fail_fast = true;
        verbose = true;
      };
      prettier = {
        enable = true;
        description = "pre commit hook for prettier";
        fail_fast = true;
        verbose = true;
        settings = {
          write = true;
        };
      };
      typos = {
        enable = true;
        description = "pre commit hook for typos";
        fail_fast = true;
        verbose = true;
        settings = {
          write = true;
          configuration = ''
            [default.extend-words]
            "ags" = "ags";
            "GIR" = "GIR";
            "flate" = "flate";
            "fo" = "fo";
          '';
        };
      };
      editorconfig-checker = {
        enable = false; # Change to true if needed
        description = "pre commit hook for editorconfig";
        fail_fast = true;
        verbose = true;
        always_run = true;
      };
      # treefmt = {
      #   enable = true;
      #   description = "pre commit hook for treefmt";
      #   fail_fast = true;
      #   verbose = true;
      #   package = inputs.treefmt.build.wrapper;
      # };
    };
  };
}
