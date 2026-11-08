---
ia-translate: true
title: Anti-aliasing do Impeller
description: Como o Impeller faz o anti-aliasing?
---

Aliasing são os artefatos visuais que resultam do desenho de geometria em uma grade
de pixels (rasterização). Os artefatos aparecem como bordas irregulares ou serrilhadas
nas formas. O Impeller usa algumas técnicas para suavizar o mapeamento para gráficos
rasterizados (anti-aliasing).

## Técnicas {:#techniques}

### Anti-aliasing multiamostragem (MSAA) {:#multisample-anti-aliasing-msaa}

[MSAA][MSAA] é uma técnica global de anti-aliasing que opera sobre todo o conteúdo
da tela. É uma otimização em relação a renderizar a tela inteira em uma escala maior
e reduzi-la depois ([SSAA][SSAA]). Em vez de fazer a operação de fragmento para cada
subamostra, o cálculo do pixel é duplicado entre as subamostras em que ocorre uma
verificação de limites. Isso limita a suavização às bordas. As GPUs de celulares têm
hardware especial para otimizar esse processo ([renderização em blocos][Tiled rendering]).
Existem diferentes níveis de quantas amostras considerar.

Em desktop e celulares, 4x MSAA é usado em todas as chamadas de renderização.

### Campos de distância com sinal ([SDFs][SDFs]) {:#signed-distance-fields-sdfs}

Normalmente, os gráficos de computador com aceleração por hardware definem uma série de
pontos e arestas (uma [malha][mesh]) e [shaders][shaders]. Já o SDF renderiza as formas
no programa de shader de fragmento como campos de distância com sinal. Como a forma é
definida no shader de fragmento, as arestas podem ser suavizadas no nível do fragmento,
em vez de depender da rasterização de uma malha.

No desktop, a renderização com SDFs vem habilitada por padrão. Nas plataformas móveis,
os SDFs são uma opção que vem desabilitada por padrão.

Essa técnica é priorizada no desktop porque a renderização com SDFs exige mais da GPU,
e o Flutter oferece suporte a celulares mais antigos. Além disso, os tamanhos físicos
dos pixels em computadores desktop costumam ser maiores que os de celulares. Assim,
qualquer imperfeição fica mais evidente neles.

### Exemplos {:#examples}

| Sem AA                                      | MSAA 4x                                        | MSAA 4x + SDF                                           |
| ------------------------------------------- | ---------------------------------------------- | ------------------------------------------------------- |
| ![Sem AA](/assets/images/docs/perf/noaa.png) | ![MSAA 4x](/assets/images/docs/perf/msaa4.png) | ![MSAA 4x + SDF](/assets/images/docs/perf/msaa4sdf.png) |

## Trabalhando com anti-aliasing {:#working-with-anti-aliasing}

### SDFs com a API FragmentShader {:#sdfs-with-the-fragmentshader-api}

As formas primitivas padrão do Flutter são desenhadas por padrão com SDFs. Se um
desenvolvedor Flutter quiser definir os próprios gráficos personalizados com SDFs,
ele pode fazer isso com a [API FragmentShader][FragmentShader API]. Usar o
[drawPath()][drawPath()] basta para a maioria dos casos de uso, sem recorrer à
renderização de SDFs de alta qualidade. Nem todos os caminhos desenhados
resultam necessariamente em renderização com SDF.

Um exemplo de renderização de SDFs com a API FragmentShader pode ser encontrado em
[`simple_sdf`][`simple_sdf`].

### Habilitando SDFs no iOS {:#enabling-sdfs-on-ios}

Os SDFs podem ser habilitados no iOS adicionando um novo campo ao `Info.plist`
do projeto.

```xml
  <key>FLTEnableSDFs</key>
  <true/>
```

[MSAA]: https://en.wikipedia.org/wiki/Multisample_anti-aliasing
[SSAA]: https://en.wikipedia.org/wiki/Supersampling
[Tiled rendering]: https://en.wikipedia.org/wiki/Tiled_rendering
[SDFs]: https://en.wikipedia.org/wiki/Signed_distance_function
[mesh]: https://en.wikipedia.org/wiki/Polygon_mesh
[shaders]: https://en.wikipedia.org/wiki/Shader
[FragmentShader API]: /ui/design/graphics/fragment-shaders
[drawPath()]: {{site.api}}/flutter/dart-ui/Canvas/drawPath.html
[`simple_sdf`]: https://github.com/flutter/samples/tree/main/simple_sdf
