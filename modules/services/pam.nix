{
  security = {
    pam = {
      # fix "too many files open" errors while writing a lot of data at once
      # was previously a huge issue when rebuilding
      loginLimits = [
        {
          domain = "@wheel";
          item = "nofile";
          type = "soft";
          value = "524288";
        }
        {
          domain = "@wheel";
          item = "nofile";
          type = "hard";
          value = "1048576";
        }
      ];

      services = {
        su = {
          # allow only users in the group wheel to login using su
          requireWheel = true;
        };
      };
    };
  };
}
