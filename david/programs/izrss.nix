#
# Rss reader for Command line
#
{
  vars,
  izrss,
  ...
}: {
  home-manager.users.${vars.user} = {
    imports = [
      izrss.homeManagerModules.default
    ];

    programs.izrss = {
      enable = true;
      urls = [
        "https://isabelroses.com/rss.xml"
        "https://uncenter.dev/feed.xml"
        "https://nixpkgs.news/rss.xml"
        "https://fasterthanli.me/index.xml"
      ];
    };
  };
}
