// Copyright 2025 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:jaspr_content/jaspr_content.dart';

/// Information about a page's source location and related URLs.
final class PageSourceInfo {
  const PageSourceInfo({
    required this.issueUrl,
    required this.translationIssueUrl,
    this.sourceUrl,
  });

  /// The URL to create a new issue for this page.
  final String issueUrl;

  /// The URL to create a new translation issue for this page
  /// (Flutter Brasil).
  final String translationIssueUrl;

  /// The URL to view the source of this page on GitHub.
  ///
  /// This will be `null` if the page doesn't have an `inputPath`.
  final String? sourceUrl;
}

extension PageSourceInfoExtension on Page {
  /// Returns the source information for this page.
  PageSourceInfo get sourceInfo {
    final pageUrl = url;
    final pageData = data.page;
    final siteData = data.site;
    final repoLinks = siteData['repo'] as Map<String, Object?>? ?? {};
    final repoUrl =
        repoLinks['this'] as String? ??
        'https://github.com/ulisseshen/flutterbrasil';
    final inputPath = pageData['inputPath'] as String?;
    final siteUrl = siteData['url'] as String? ?? 'https://docs.flutterbrasil.dev';

    final fullPageUrl = '$siteUrl$pageUrl';
    final String? pageSourceUrl;
    final String issueUrl;

    if (inputPath != null) {
      pageSourceUrl = '$repoUrl/blob/main/${inputPath.replaceAll('./', '')}';
      issueUrl =
          '$repoUrl/issues/new?template=1_page_issue.yml&'
          'page-url=$fullPageUrl&'
          'page-source=$pageSourceUrl';
    } else {
      pageSourceUrl = null;
      issueUrl =
          '$repoUrl/issues/new?template=1_page_issue.yml&'
          'page-url=$fullPageUrl';
    }

    final translationTitle = Uri.encodeComponent(
      'Problema de tradução em: $pageUrl',
    );
    final translationBody = Uri.encodeComponent(
      '**URL da página:** $fullPageUrl\n\n'
      '**Problema encontrado:**\n'
      '<!-- Descreva o problema de tradução que você encontrou -->\n\n'
      '- [ ] Página não traduzida\n'
      '- [ ] Tradução incorreta ou incompleta\n'
      '- [ ] Erro de português\n'
      '- [ ] Outro (descrever abaixo)\n\n'
      '**Descrição:**\n'
      '<!-- Explique em detalhes o problema encontrado -->\n\n',
    );
    final translationIssueUrl =
        '$repoUrl/issues/new?title=$translationTitle&body=$translationBody';

    return PageSourceInfo(
      issueUrl: issueUrl,
      translationIssueUrl: translationIssueUrl,
      sourceUrl: pageSourceUrl,
    );
  }
}
