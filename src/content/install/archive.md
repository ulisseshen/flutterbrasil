---
title: Arquivo do Flutter SDK
shortTitle: Archive
description: "Todos os lançamentos atuais do Flutter SDK: stable, beta e main."
ia-translate: true
---

{% render "docs/china-notice.md" %}

## Visão geral

O arquivo do Flutter SDK é uma coleção de todas as versões anteriores do
Flutter SDK. Este arquivo é útil para desenvolvedores que precisam usar uma
versão mais antiga do Flutter por razões de compatibilidade ou para investigar bugs.

O arquivo inclui Flutter SDKs para Windows, macOS e Linux nos
seguintes [channels][]:

*   **Canal estável (Stable channel)**: Este canal contém as builds mais estáveis do Flutter.
    Aproximadamente a cada terceira versão beta é promovida para a versão estável.
    O canal estável é o canal recomendado para
    novos usuários e para lançamentos de aplicativos em produção.

*   **Canal beta (Beta channel)**: Este canal é a versão mais recente do Flutter que está
    disponível, mas ainda não é estável. O branch beta é geralmente lançado
    na primeira quarta-feira do mês. Uma correção normalmente chega ao
    canal beta cerca de duas semanas após ser integrada ao canal main.
    Os lançamentos são distribuídos como [installation bundles][].

*   **Canal main (Main channel)**: Este canal tem os recursos mais novos, mas não foi totalmente
    testado e pode ter alguns bugs. Não recomendamos usá-lo, a menos que você esteja
    contribuindo para o próprio Flutter.

As seguintes informações estão disponíveis para cada lançamento do Flutter no
arquivo do SDK:

*   **Versão do Flutter (Flutter version)**: O número da versão do Flutter SDK
    (por exemplo, 3.35.0, 2.10.5) segue um esquema modificado de
    [versionamento de calendário][calendar versioning] chamado _CalVer_.
    Para mais informações, visite a página [Flutter SDK versioning][].
*   **Arquitetura (Architecture)**: A arquitetura do processador para a qual o SDK foi construído
    (por exemplo, x64, arm64). Isso especifica o tipo de processador com o qual o SDK é
    compatível.
*   **Ref**: O hash do commit git que identifica exclusivamente a base de código específica
    usada para aquele lançamento.
*   **Data de lançamento (Release Date)**: A data em que aquela versão específica do Flutter foi
    oficialmente lançada.
*   **Versão do Dart (Dart version)**: A versão correspondente do Dart SDK incluída no
    lançamento do Flutter SDK.
*   **Proveniência (Provenance)**: Fornece detalhes sobre o processo de build e a origem do
    SDK, potencialmente incluindo informações sobre atestações de segurança ou
    sistemas de build usados. Os resultados são retornados como JSON.

[calendar versioning]: https://calver.org/
[Flutter SDK versioning]: {{site.repo.flutter}}/blob/main/docs/releases/Release-versioning.md

## Canal estável (Stable channel)

<Tabs key="os-archive-tabs">
    <Tab name="Windows">
        <ArchiveTable os="Windows" channel="stable" />
    </Tab>
    <Tab name="macOS">
        <ArchiveTable os="macOS" channel="stable" />
    </Tab>
    <Tab name="Linux">
        <ArchiveTable os="Linux" channel="stable" />
    </Tab>
</Tabs>

## Canal beta (Beta channel)

<Tabs key="os-archive-tabs">
    <Tab name="Windows">
        <ArchiveTable os="Windows" channel="beta" />
    </Tab>
    <Tab name="macOS">
        <ArchiveTable os="macOS" channel="beta" />
    </Tab>
    <Tab name="Linux">
        <ArchiveTable os="Linux" channel="beta" />
    </Tab>
</Tabs>

<a id="master-channel" aria-hidden="true"></a>

## Canal main (Main channel)

[Pacotes de instalação][Installation bundles] não estão disponíveis para o canal `main`
(que anteriormente era conhecido como canal `master`).
No entanto, você pode obter o SDK diretamente do
[repositório no GitHub][GitHub repo] clonando o canal main,
e então disparando um download das dependências do SDK:

```console
$ git clone -b main https://github.com/flutter/flutter.git
$ ./flutter/bin/flutter --version
```

## Mais informações

Para saber o que há de novo nas principais builds do Flutter, confira a
página de [notas de lançamento][release notes].

Para detalhes sobre como nossos pacotes de instalação são estruturados,
consulte [Installation bundles][].

[channels]: {{site.repo.flutter}}/blob/main/docs/releases/Flutter-build-release-channels.md
[release notes]: /release/release-notes
[GitHub repo]: {{site.repo.flutter}}
[Installation bundles]: {{site.repo.flutter}}/blob/main/docs/infra/Flutter-Installation-Bundles.md
