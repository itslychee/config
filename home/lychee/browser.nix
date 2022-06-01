{ pkgs, config, ... }:
{
  config.programs.firefox = {
    enable = true;
    package = pkgs.firefox-bin;
    extensions = with pkgs.nur.repos.rycee.firefox-addons; [
      bitwarden
      privacy-badger
      ublock-origin
      i-dont-care-about-cookies
      no-pdf-download
      octolinker
      old-reddit-redirect
      sponsorblock
      (buildFirefoxXpiAddon {
        pname = "mal-sync";
        addonId = "{1f3ebd01-f55f-44d0-a057-e3cd89169018}";
        version = "0.8.20";
        url = "https://addons.mozilla.org/firefox/downloads/file/3926335/mal_sync-0.8.20.xpi";
        sha256 = "3m9wgaVK9plQfkeFVmFEqJm4vuMeUhOWoGXWeLBan2I=";
        meta = with pkgs.lib; {
          homepage = "https://github.com/MALSync/MALSync";
          description = "MAL-Sync enables automatic episode tracking between MyAnimeList/Anilist/Kitsu/Simkl and multiple anime streaming websites.";
          license = licenses.gpl3;
          platforms = platforms.all;
        };
      })
    ];
    profiles = {
      lychee = {
        isDefault = true;
        bookmarks = {
           "HM Options".url = "https://rycee.gitlab.io/home-manager/options.html";
        };
        settings = {
          "devtools.theme" = "white";
          "services.sync.prefs.sync.browser.uiCustomization.state" = true;
          "signon.rememberSignons" = false;
          "browser.shell.checkDefaultBrowser" = false;
          "media.videocontrols.picture-in-picture.video-toggle.enabled" = false;
          "extensions.htmlaboutaddons.recommendations.enabled" = false;
          "extensions.htmlaboutaddons.discover.enabled" = false;
          "extensions.pocket.enabled" = false;
          "app.normandy.enabled" = false;
          "app.normandy.api_url" = "";
          "extensions.shield-recipe-client.enabled" = false;
          "app.shield.optoutstudies.enabled" = false;
          "reader.parse-on-load.enabled" = false;
          "browser.search.hiddenOneOffs" = "Google,Amazon.com,Bing,DuckDuckGo,eBay,Wikipedia (en)";

          # general settings
          "browser.tabs.inTitlebar" = 1;
          "general.autoScroll" = true;
          "general.smoothScroll" = false;
          "browser.fullscreen.autohide" = false;
          "browser.aboutConfig.showWarning" = false;

          # remove the bullshit firefox inserts
          "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
          "browser.newtabpage.activity-stream.feeds.section.topsites" = false;
          "browser.newtabpage.activity-stream.telemetry" = false;
          "browser.urlbar.sponsoredTopSites" = false;
          "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
          "browser.newtabpage.activity-stream.showSponsored" = false;
          "browser.search.suggest.enabled" = false;
          "browser.urlbar.quicksuggest.enabled" = false;
          "browser.urlbar.quicksuggest.remoteSettings.enabled" = false;

          # quick find
          "accessibility.typeaheadfind.manual" = false;
          "accessibility.typeaheadfind" = false;
          "accessibility.typeaheadfind.autostart" = false;

          # Fontconfig
          "font.size.variable.x-western" = 14;

          # Beacon async http transfers
          "beacon.enabled" = false;
          "browser.send_pings" = true;
          # Domain guessing
          "browser.fixup.alternate.enabled" = false;

          # Telemetry & experiments
          "toolkit.telemetry.enabled" = false;
          "toolkit.telemetry.unified" = false;
          "toolkit.telemetry.archive.enabled" = false;
          "experiments.supported" = false;
          "experiments.enabled" = false;
          "experiments.manifest.uri" = "";

          # Health reports
          "datareporting.healthreport.uploadEnabled" = false;
          "datareporting.healthreport.service.enabled" = false;
          "datareporting.policy.dataSubmissionEnabled" = false;
        };
      };
    };
  };

}
