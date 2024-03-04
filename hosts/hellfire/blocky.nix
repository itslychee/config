{
  services.blocky = {
    enable = true;
    settings = {
        caching = {
            minTime = "20m";
            prefetching = true;
        };
        bootstrapDns = [
            "tcp+udp:1.1.1.1"
        ];
        customDNS = {
            customTTL = "24h";
            mapping = {
                "hearth.lan" = "192.168.0.3";
                "pi.lan" = "192.168.0.2";
            };
        };
        blocking.blackLists.ads = [
          "https://adaway.org/hosts.txt"
          "https://hostfiles.frogeye.fr/firstparty-trackers-hosts.txt"
          "https://pgl.yoyo.org/adservers/serverlist.php?hostformat=hosts&showintro=0&mimetype=plaintext"
          "https://raw.githubusercontent.com/FadeMind/hosts.extras/master/add.2o7Net/hosts"
          "https://raw.githubusercontent.com/anudeepND/blacklist/master/adservers.txt"
          "https://raw.githubusercontent.com/bigdargon/hostsVN/master/hosts"
          "https://raw.githubusercontent.com/crazy-max/WindowsSpyBlocker/master/data/hosts/spy.txt"
          "https://s3.amazonaws.com/lists.disconnect.me/simple_ad.txt"
          "https://v.firebog.net/hosts/AdguardDNS.txt"
          "https://v.firebog.net/hosts/Admiral.txt"
          "https://v.firebog.net/hosts/Easylist.txt"
          "https://v.firebog.net/hosts/Easyprivacy.txt"
          "https://v.firebog.net/hosts/Prigent-Ads.txt"
        ];
        blocking.clientGroupsBlock.default = [ "ads" ];
    };
  };
}
