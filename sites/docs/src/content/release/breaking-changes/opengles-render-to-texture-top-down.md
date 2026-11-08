---
ia-translate: true
title: O conteúdo de render-to-texture do OpenGL ES é armazenado de cima para baixo
description: >-
  O backend OpenGL ES do Impeller agora armazena o conteúdo de render-to-texture
  de cima para baixo, igual ao Metal e ao Vulkan, o que pode afetar fragment shaders
  e apps do Flutter GPU que compensavam a orientação anterior de baixo para cima.
---

{% render "docs/breaking-changes.md" %}

## Resumo {:#summary}

O backend OpenGL ES do Impeller agora armazena o conteúdo de render-to-texture
de cima para baixo, da mesma forma que os backends Metal e Vulkan.
Um fragment shader ou um app do Flutter GPU que amostrava uma textura de render target
no OpenGL ES e adicionava um espelhamento vertical para compensar a
orientação antiga de baixo para cima agora renderiza esse conteúdo de cabeça para baixo.

## Contexto {:#background}

O backend OpenGL ES armazenava anteriormente o conteúdo de render-to-texture de baixo para cima,
diferente dos backends Metal e Vulkan.
O renderizador carregava essa diferença de orientação em cada amostragem de textura
como uma escala da coordenada Y por sampler.
Agora o Impeller absorve a diferença uma única vez, no estágio de vértice, de modo que
as texturas de render target são armazenadas de cima para baixo em todos os backends.

Essa mudança é invisível para o framework e para a renderização 2D do Flutter.
O código do aplicativo só pode observar a orientação antiga pela
API `FragmentShader` e pelo Flutter GPU,
o pacote experimental `flutter_gpu`,
em que um shader amostra uma textura de render target diretamente.

## Guia de migração {:#migration-guide}

Shaders escritos para OpenGL ES frequentemente invertiam a
coordenada Y dentro de um bloco `IMPELLER_TARGET_OPENGLES` para que as
texturas de render target coincidissem com os outros backends.
As texturas de render target agora são de cima para baixo em todos os backends,
então essa inversão não é mais necessária.

Código antes da migração:

```glsl
void main() {
  vec2 uv = FlutterFragCoord().xy / u_size;
#ifdef IMPELLER_TARGET_OPENGLES
  uv.y = 1.0 - uv.y;
#endif
  fragColor = texture(u_texture, uv);
}
```

Se o shader precisa rodar apenas em uma versão do Flutter que
inclua essa mudança, remova a inversão.

Código após a migração:

```glsl
void main() {
  vec2 uv = FlutterFragCoord().xy / u_size;
  fragColor = texture(u_texture, uv);
}
```

Para manter um único código-fonte funcionando em várias versões, proteja a inversão com a
macro `IMPELLER_OPENGLES_UNFLIPPED_DEPRECATED`.
Essa macro só é definida em versões que armazenam as texturas de render target
de cima para baixo, então a inversão continua sendo executada nas versões antigas que precisam dela.

```glsl
void main() {
  vec2 uv = FlutterFragCoord().xy / u_size;
#if defined(IMPELLER_TARGET_OPENGLES) && !defined(IMPELLER_OPENGLES_UNFLIPPED_DEPRECATED)
  uv.y = 1.0 - uv.y;
#endif
  fragColor = texture(u_texture, uv);
}
```

## Linha do tempo {:#timeline}

Incluído na versão: 3.46.0-0.1.pre<br>
Na versão estável: 3.47

## Referências {:#references}

Issue no GitHub:

* [Issue 186554][]

PRs relevantes:

* [PR 186556][]
* [PR 187316][]

[Issue 186554]: {{site.repo.flutter}}/issues/186554
[PR 186556]: {{site.repo.flutter}}/pull/186556
[PR 187316]: {{site.repo.flutter}}/pull/187316
