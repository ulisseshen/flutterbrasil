// Copyright 2025 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:jaspr/jaspr.dart';
import 'package:universal_web/web.dart' as web;

import '../../../util.dart';
import '../button.dart';

/// The cookie banner to show on a user's first time visiting the site.
@client
final class CookieNotice extends StatefulComponent {
  const CookieNotice({super.key});

  @override
  State<CookieNotice> createState() => _CookieNoticeState();
}

final class _CookieNoticeState extends State<CookieNotice> {
  static const _cookieStorageKey = 'cookie-consent';

  bool showNotice = false;

  @override
  void initState() {
    if (kIsWeb) {
      var shouldShowNotice = true;
      if (web.window.localStorage.getItem(_cookieStorageKey)
          case final lastConsentedMs?) {
        if (int.tryParse(lastConsentedMs) case final msFromEpoch?) {
          final consentedDateTime = DateTime.fromMillisecondsSinceEpoch(
            msFromEpoch,
          );
          final difference = consentedDateTime.difference(DateTime.now());
          if (difference.inDays < 180) {
            // If consented less than 180 days ago, don't show the notice.
            shouldShowNotice = false;
          }
        }
      }

      showNotice = shouldShowNotice;
    }
    super.initState();
  }

  @override
  Component build(BuildContext context) {
    return section(
      id: 'cookie-notice',
      classes: [if (showNotice) 'show'].toClasses,
      attributes: {'data-nosnippet': 'true'},
      [
        div(classes: 'container', [
          p([
            text(
              'O docs.flutterbrasil.dev usa cookies do Google para fornecer e '
              'melhorar a qualidade de seus serviços e para analisar o tráfego.',
            ),
          ]),
          div(classes: 'button-group', [
            const Button(
              content: 'Saiba mais',
              href: 'https://policies.google.com/technologies/cookies',
              attributes: {'target': '_blank', 'rel': 'noopener'},
            ),
            Button(
              content: 'OK, entendi',
              style: ButtonStyle.filled,
              onClick: () {
                web.window.localStorage.setItem(
                  _cookieStorageKey,
                  DateTime.now().millisecondsSinceEpoch.toString(),
                );
                setState(() {
                  showNotice = false;
                });
              },
            ),
          ]),
        ]),
      ],
    );
  }
}
