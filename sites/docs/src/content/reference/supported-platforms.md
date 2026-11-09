---
ia-translate: true
title: Plataformas de implantação suportadas
shortTitle: Plataformas suportadas
description: As plataformas que Flutter suporta por versão de plataforma.
showBreadcrumbs: false
---

Na versão Flutter {{site.documentedFlutterVersion}},
Flutter suporta a implantação de apps nas seguintes combinações de
arquiteturas de hardware e versões de sistema operacional.
Essas combinações são chamadas de _plataformas_.

Flutter categoriza as plataformas da seguinte forma:

* **Supported** (Suportadas): As plataformas e versões que o time Flutter suporta.
* **CI-tested** (Testadas em CI): O time Flutter testa essas plataformas em cada commit.
* **Unsupported** (Não suportadas): O time Flutter não testa ou suporta essas plataformas.

Com base nessas categorias,
Flutter suporta a implantação nas seguintes plataformas.

## Plataformas móveis {:#mobile-platforms}

<PlatformsGrid>
  <PlatformCard
    name="Android"
    icon="mobile"
    arch="x64, Arm32, Arm64"
    supported="24 a 37"
    ci-tested="24 a 36"
    unsupported="23 e anteriores"
    deploy-to-link="/deployment/android"
  />
  <PlatformCard
    name="iOS"
    icon="mobile"
    arch="Arm64"
    supported="15 a 27"
    ci-tested="18 e 26"
    unsupported="14 e anteriores"
    deploy-to-link="/deployment/ios"
  />
</PlatformsGrid>

## Plataformas desktop {:#desktop-platforms}

:::warning Descontinuação do macOS Intel (x64)
Conforme a Apple descontinua os Macs baseados em Intel,
o Flutter está descontinuando o suporte ao hardware Intel (x64).
Para detalhes sobre o cronograma e o impacto,
consulte a [estratégia de descontinuação do macOS Intel][macOS Intel deprecation strategy].

[macOS Intel deprecation strategy]: {{site.main-url}}/go/macos-intel-deprecation
:::

<PlatformsGrid>
  <PlatformCard
    name="Windows"
    icon="desktop_windows"
    arch="x64, Arm64"
    supported="10, 11"
    ci-tested="10"
    unsupported="8 e anteriores"
    deploy-to-link="/deployment/windows"
  />
  <PlatformCard
    name="macOS"
    icon="laptop_mac"
    arch="x64, Arm64"
    supported="Monterey (12) a Golden Gate (27)"
    ci-tested="Sequoia (15)"
    unsupported="Big Sur (11) e anteriores"
    deploy-to-link="/deployment/macos"
  />
  <PlatformCard
    name="Debian (Linux)"
    icon="computer"
    arch="x64, Arm64"
    deploy-to="Linux"
    supported="10 a 13"
    ci-tested="12"
    unsupported="9 e anteriores"
    deploy-to-link="/deployment/linux"
  />
  <PlatformCard
    name="Ubuntu (Linux)"
    icon="computer"
    arch="x64, Arm64"
    deploy-to="Linux"
    supported="20.04 LTS a 24.04 LTS"
    ci-tested="22.04 LTS"
    unsupported="25.10 e anteriores, não LTS"
    deploy-to-link="/deployment/linux"
  />
</PlatformsGrid>

## Plataformas web {:#web-platforms}

<PlatformsGrid>
  <PlatformCard
    name="Chrome"
    icon="language"
    arch="JavaScript, WebAssembly"
    deploy-to="web"
    supported="[Últimas 2](https://chromereleases.googleblog.com/search/label/Stable%20updates)"
    ci-tested="145"
    unsupported="95 e anteriores"
    deploy-to-link="/deployment/web"
  />
  <PlatformCard
    name="Firefox"
    icon="language"
    arch="JavaScript"
    deploy-to="web"
    supported="[Últimas 2](https://www.mozilla.org/en-US/firefox/releases/)"
    ci-tested="148"
    unsupported="98 e anteriores"
    deploy-to-link="/deployment/web"
  />
  <PlatformCard
    name="Safari"
    icon="language"
    arch="JavaScript"
    deploy-to="web"
    supported="15.6 e posteriores"
    ci-tested="18.6"
    unsupported="15.5 e anteriores"
    deploy-to-link="/deployment/web"
  />
  <PlatformCard
    name="Edge"
    icon="language"
    arch="JavaScript, WebAssembly"
    deploy-to="web"
    supported="[Últimas 2](https://learn.microsoft.com/en-us/deployedge/microsoft-edge-relnote-stable-channel)"
    ci-tested="145"
    unsupported="95 e anteriores"
    deploy-to-link="/deployment/web"
  />
</PlatformsGrid>

## Versões anteriores do Flutter {:#previous-flutter-versions}

Para conhecer o suporte a versões anteriores do Flutter,
consulte os seguintes recursos:

*   [Notas de lançamento do SDK do Flutter][Flutter SDK release notes].
    Encontre as mudanças incompatíveis e as atualizações de suporte listadas por versão.
*   [Histórico da página de plataformas suportadas][supported-platforms-history].
    Para ver as matrizes de suporte históricas,
    visualize as versões anteriores desta página.

[Flutter SDK release notes]: /release/release-notes
[supported-platforms-history]: {{site.repo.this}}/commits/main/sites/docs/src/content/reference/supported-platforms.md
