---
title: Flutter on iOS
description: >-
  Learn about Flutter's support for and compatibility with
  the latest releases of iOS.
---

You can develop Flutter on the iOS platform, even on
the latest release of iOS. The latest Flutter SDK
already supports a number of the features in the
latest release of iOS.

Of course, if you find a bug on Flutter,
please [file an issue][].

[file an issue]: {{site.github}}/flutter/flutter/issues

## iOS 18 release

The following table shows the status of support for
the iOS 18 release as of the Flutter 3.24.3 release.

| Feature | Status |
|---------|--------|
| Target and build for iOS 18 | Delivered, supported |
| Control Center (CC) widgets | Delivered, [supported][cc] Requires writing some Swift code to create a toggle for the CC |
| Light/dark/tinted icon colors | Delivered, [supported][icon] | 
| Password apps work/integrate work with Flutter | Delivered, supported |
| Eye tracking of a Flutter app | Partially works; [known issues][eye] |
| iPhone mirroring (when viewing a Flutter app) | Partially works; [known issues][mirror] |
| iOS formatting menu | Not yet available; on roadmap |
| Showing Translate option for the context edit menu | Not yet available; on roadmap |
| Apple Intelligence (AI), such as New Writing Tools | Not yet available; on roadmap |
| iOS-style zoom page transition | Not yet available; on roadmap |
| Hover typing feature | Not available |
| [iPad-style tab bar][] | Not available |
| Large content viewer | Not available |
| Virtual trackpad feature | Not available |
{% comment %}
{% endcomment %}
{:.table .table-striped}

[icon]: /deployment/ios#add-an-app-icon
[cc]: /platform-integration/ios/app-extensions
[eye]: {{site.github}}/flutter/flutter/issues/153573
[iPad-style tab bar]: {{site.apple-dev}}/documentation/uikit/app_and_environment/elevating_your_ipad_app_with_a_tab_bar_and_sidebar
[mirror]: {{site.github}}/flutter/flutter/issues/152711
