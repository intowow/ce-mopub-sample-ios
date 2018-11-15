# ce-mopub-sample-ios

## Mediate CrystalExpress Ads through MoPub

The full integration guide: https://intowow.gitbooks.io/crystalexpress-documentation-v3-x/content/mediation/mopub/ios.html

The CrystalExpress MoPub Adapter allows MoPub publishers to add CrystalExpress as a Custom Ad Network within the MoPub platform.

CrystalExpress provides four ad formats for MoPub mediation. The relationship between MoPub ad unit and ad format in CrystalExpress is as following:

| MoPub ad unit | AD format from CrystalExpress |
| --- | --- |
| Banner or Medium | Card AD |
| Rewarded Video | Rewarded Video AD |
| Interstitial | Splash AD |
| Native | Native AD |

Before you start add CrystalExpress as Custom network, you have to integrate MoPub SDK by following the instructions on the [MoPub website](https://github.com/mopub/mopub-ios-sdk/wiki/Getting-Started#app-transport-security-settings).

** NOTICE: This porject does not contain CrystalExpress SDK. Please contact your Intowow account manager. We will provide the appropriate version of SDK and Crystal ID to fit your needs.**

The custom event is under folder 'MoPubDemo/CrystalExpress_MoPub_Plugins/'


## CHANGELOG

#### Version 6 (2018-11-15)
* Refine custom event for new CrystalExpress SDK interface.


#### Version 5 (2018-03-23)
* Refine custom event for new CrystalExpress SDK interface.


#### Version 4 (2018-01-05)
* MoPub custom event support interstitial format.
* MoPub custom event support rewarded video format
* MoPub native adapter can get cover image size.


#### Version 3 (2017-10-25)
* MoPub custom event supports audience tag.


#### Version 2 (2017-08-02)

#### Features
* Remove timeout setting in MoPub custom event.
* Banner custom event will return ad at the middle of specific area.

#### Version 1 (2017-06-23)

#### Features
* Implement MoPub SDK adapter and sample code.