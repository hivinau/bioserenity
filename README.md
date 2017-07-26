# iOS app for BioSerenity test

[![XCode](https://img.shields.io/badge/stable-v8.3.3-ff69b4.svg)](https://itunes.apple.com/fr/app/xcode/id497799835?mt=12)

## Package manager

**[Carthage](https://github.com/carthage/carthage)**


Make sure you are running the latest version of Carthage by running:

```bash
brew update
brew upgrade carthage
```

_We recommend using Carthage version 0.17.2 or later._


### Dependencies

Frameworks used by this iOS app :
- [Starscream](https://github.com/daltoniam/Starscream) &ndash; Manage WebSocket communications.
- [HGCircularSlider](https://github.com/HamzaGhazouani/HGCircularSlider) &ndash; Show speed on circular slider.
- [RxSwift](https://github.com/ReactiveX/RxSwift) &ndash; Enable easy composition of asynchronous operations and event/data streams.

Please make sure required dependencies are located on [dependencies](dependencies).
If not, see [tutorials](https://www.raywenderlich.com/109330/carthage-tutorial-getting-started)


_If "Missing required modules: 'CZLib', 'CommonCrypto'" issue appears, please reload Starscream.framework using Carthage._

## About
### License

This iOS app is licensed under the [APACHE License](https://github.com/hivinau/bioserenity/blob/master/LICENSE).
