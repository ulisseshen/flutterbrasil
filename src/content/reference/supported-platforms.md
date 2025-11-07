---
ia-translate: true
title: Plataformas de deploy suportadas
short-title: Plataformas suportadas
description: As plataformas que o Flutter suporta por versão de plataforma.
---

A partir do Flutter {{site.appnow.flutter}},
o Flutter suporta deploy de apps nas seguintes combinações de
arquiteturas de hardware e versões de sistema operacional.
Essas combinações são chamadas de _plataformas_.

O Flutter categoriza plataformas da seguinte forma:

* **Supported**: As plataformas e versões que a equipe do Flutter suporta.
* **CI-tested**: A equipe do Flutter testa essas plataformas em cada commit.
* **Unsupported**: A equipe do Flutter não testa nem suporta essas plataformas.

Com base nessas categorias,
o Flutter suporta deploy nas seguintes plataformas.

{% assign opsys = platforms %}

| Plataforma alvo | Arquiteturas alvo | Versões suportadas | Versões testadas em CI |  Versões não suportadas |
|---|:---:|:---:|:---:|:---:|
{%- for platform in opsys %}
  | {{platform.platform}} | {{platform.target-arch}} | {{platform.supported}} | {{platform.ci-tested}} | {{platform.unsupported}} |
{%- endfor %}

{:.table .table-striped}
