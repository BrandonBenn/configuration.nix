{ pkgs, ... }:
{
    programs.firefox = {
    enable = true;
    package = pkgs.wrapFirefox pkgs.firefox-unwrapped {
        extraPolicies = {
            CaptivePortal = false;
            DisableFirefoxStudies = true;
            DisablePocket = true;
            DisableTelemetry = true;
            DisableFirefoxAccounts = true;
            NoDefaultBookmarks = true;
            OfferToSaveLogins = false;
            OfferToSaveLoginsDefault = false;
            PasswordManagerEnabled = false;
            FirefoxHome = {
                Search = false;
                Pocket = false;
                Snippets = false;
                TopSites = false;
                Highlights = false;
            };
            UserMessaging = {
                ExtensionRecommendations = false;
                SkipOnboarding = true;
            };
        };
    };
    profiles.brandon.isDefault = true;
    profiles.brandon.settings = {
      "extensions.pocket.enabled" = false;
      "browser.tabs.firefox-view" = false;
      "browser.tabs.firefox-view-next" = false;
      "browser.toolbars.bookmarks.visibility" = "never";
      "browser.startup.homepage" = "about:blank";
    };
  };
}
