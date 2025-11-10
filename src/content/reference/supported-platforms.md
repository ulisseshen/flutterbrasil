---
ia-translate: true
title: Plataformas de implantação suportadas
shortTitle: Plataformas suportadas
description: As plataformas que Flutter suporta por versão de plataforma.
showBreadcrumbs: false
---

Na versão Flutter {{site.currentFlutterVersion}},
Flutter suporta a implantação de apps nas seguintes combinações de
arquiteturas de hardware e versões de sistema operacional.
Essas combinações são chamadas de _plataformas_.

Flutter categoriza as plataformas da seguinte forma:

* **Supported** (Suportadas): As plataformas e versões que o time Flutter suporta.
* **CI-tested** (Testadas em CI): O time Flutter testa essas plataformas em cada commit.
* **Unsupported** (Não suportadas): O time Flutter não testa ou suporta essas plataformas.

Com base nessas categorias,
Flutter suporta a implantação nas seguintes plataformas.

{% assign opsys = platforms %}

| Plataforma de destino | Arquiteturas de destino | Versões suportadas | Versões testadas em CI | Versões não suportadas |
|---|:---:|:---:|:---:|:---:|
{%- for platform in opsys %}
  | {{platform.platform}} | {{platform.target-arch}} | {{platform.supported}} | {{platform.ci-tested}} | {{platform.unsupported}} |
{%- endfor %}

{:.table .table-striped}
