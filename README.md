# SoftEther VPN for Android
An Open-Source Cross-platform Multi-protocol VPN Program
This not the official SoftEther VPN client for Android

# Prerequisites

* JDK 1.8
* CMake 3.6+
* Android SDK
  - Build Tools 25+
* Android NDK r15+

# Building
```bash
    # install and update all git submodule
    git clone https://github.com/lfasmpao/softethervpn-android
    cd softethervpn-android
    git submodule update --init
    # then fire up Android Studio
```

# Development
Want to contribute? Great!
SoftEther VPN for Android uses Java for development.
Make a change in your file and instantanously see your updates!

### Did you find this useful?
[![ko-fi](https://www.ko-fi.com/img/donate_sm.png)](https://ko-fi.com/lfasmpao)

### License
Apache License 2.0

# Footnotes
- There's a prebuilt softether under `app/src/main/assets` to get start working with the UI
- The enviroment configured to compile softether which will cost lots of time if you are developing, you can disable the `externalNativeBuild` in `app/build.gradle` and use the prebuilt softether binaries.
- you should run `hamcorebuilder` on your device to get the hamcore.se2 (if you are compiling softether)