---
ia-translate: true
title: Plataformas de Implantação Suportadas
short-title: Plataformas Suportadas
description: As plataformas que o Flutter suporta por versão de plataforma.
---

A partir do Flutter {{site.appnow.flutter}},
o Flutter suporta a implantação de aplicativos nas seguintes combinações de
arquiteturas de hardware e versões de sistema operacional.
Essas combinações são chamadas de _plataformas_.

O Flutter categoriza as plataformas da seguinte forma:

*   **Suportado**: As plataformas e versões que a equipe Flutter suporta.
*   **Testado em CI**: A equipe Flutter testa essas plataformas em cada commit.
*   **Não Suportado**: A equipe Flutter não testa ou suporta essas plataformas.

Com base nessas categorias,
o Flutter suporta a implantação nas seguintes plataformas.

{% assign opsys = platforms %}

| Plataforma alvo | Arquiteturas alvo | Versões suportadas | Versões testadas em CI | Versões não suportadas |
|---|:---:|:---:|:---:|:---:|
{%- for platform in opsys %}
  | {{platform.platform}} | {{platform.target-arch}} | {{platform.supported}} | {{platform.ci-tested}} | {{platform.unsupported}} |
{%- endfor %}

{:.table .table-striped}
