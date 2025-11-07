---
title: Escrevendo e usando fragment shaders
description: Como criar e usar fragment shaders para criar efeitos visuais customizados no seu aplicativo Flutter.
short-title: Fragment shaders
ia-translate: true
---

:::note
Tanto o backend Skia quanto o [Impeller][] suportam escrever um
shader customizado. Exceto onde indicado, as mesmas
instruções se aplicam a ambos.
:::

[Impeller]: /perf/impeller

Shaders customizados podem ser usados para fornecer efeitos gráficos ricos
além daqueles fornecidos pelo Flutter SDK.
Um shader é um programa criado em uma linguagem pequena,
semelhante ao Dart, conhecida como GLSL,
e executado na GPU do usuário.

Shaders customizados são adicionados a um projeto Flutter
listando-os no arquivo `pubspec.yaml`,
e obtidos usando a API [`FragmentProgram`][].

[`FragmentProgram`]: {{site.api}}/flutter/dart-ui/FragmentProgram-class.html

## Adicionando shaders a um aplicativo

Shaders, na forma de arquivos GLSL com a extensão `.frag`,
devem ser declarados na seção `shaders` do arquivo `pubspec.yaml` do seu projeto.
A ferramenta de linha de comando do Flutter compila o shader
para seu formato de backend apropriado,
e gera seus metadados de tempo de execução necessários.
O shader compilado é então incluído no aplicativo como um asset.

```yaml
flutter:
  shaders:
    - shaders/myshader.frag
```

Ao executar em modo de depuração,
alterações em um programa shader acionam recompilação
e atualizam o shader durante hot reload ou hot restart.

Shaders de pacotes são adicionados a um projeto
com `packages/$pkgname` prefixado ao nome do programa shader
(onde `$pkgname` é o nome do pacote).

### Carregando shaders em tempo de execução

Para carregar um shader em um objeto `FragmentProgram` em tempo de execução,
use o construtor [`FragmentProgram.fromAsset`][].
O nome do asset é o mesmo que o caminho para o shader
fornecido no arquivo `pubspec.yaml`.

[`FragmentProgram.fromAsset`]: {{site.api}}/flutter/dart-ui/FragmentProgram/fromAsset.html

```dart
void loadMyShader() async {
  var program = await FragmentProgram.fromAsset('shaders/myshader.frag');
}
```

O objeto `FragmentProgram` pode ser usado para criar
uma ou mais instâncias de [`FragmentShader`][].
Um objeto `FragmentShader` representa um fragment program
junto com um conjunto específico de _uniforms_ (parâmetros de configuração).
Os uniforms disponíveis dependem de como o shader foi definido.

[`FragmentShader`]: {{site.api}}/flutter/dart-ui/FragmentShader-class.html

```dart
void updateShader(Canvas canvas, Rect rect, FragmentProgram program) {
  var shader = program.fragmentShader();
  shader.setFloat(0, 42.0);
  canvas.drawRect(rect, Paint()..shader = shader);
}
```

### API Canvas

Fragment shaders podem ser usados com a maioria das APIs Canvas
definindo [`Paint.shader`][].
Por exemplo, ao usar [`Canvas.drawRect`][]
o shader é avaliado para todos os fragmentos dentro do retângulo.
Para uma API como [`Canvas.drawPath`][] com um caminho contornado,
o shader é avaliado para todos os fragmentos dentro da linha contornada.
Algumas APIs, como [`Canvas.drawImage`][], ignoram o valor do shader.

[`Canvas.drawImage`]:  {{site.api}}/flutter/dart-ui/Canvas/drawImage.html
[`Canvas.drawRect`]:   {{site.api}}/flutter/dart-ui/Canvas/drawRect.html
[`Canvas.drawPath`]:   {{site.api}}/flutter/dart-ui/Canvas/drawPath.html
[`Paint.shader`]:      {{site.api}}/flutter/dart-ui/Paint/shader.html

```dart
void paint(Canvas canvas, Size size, FragmentShader shader) {
  // Draws a rectangle with the shader used as a color source.
  canvas.drawRect(
    Rect.fromLTWH(0, 0, size.width, size.height),
    Paint()..shader = shader,
  );

  // Draws a stroked rectangle with the shader only applied to the fragments
  // that lie within the stroke.
  canvas.drawRect(
    Rect.fromLTWH(0, 0, size.width, size.height),
    Paint()
      ..style = PaintingStyle.stroke
      ..shader = shader,
  )
}

```

## Criando shaders

Fragment shaders são criados como arquivos fonte GLSL.
Por convenção, esses arquivos têm a extensão `.frag`.
(O Flutter não suporta vertex shaders,
que teriam a extensão `.vert`.)

Qualquer versão GLSL de 460 até 100 é suportada,
embora alguns recursos disponíveis sejam restritos.
O restante dos exemplos neste documento usa a versão `460 core`.

Os shaders estão sujeitos às seguintes limitações
quando usados com Flutter:

* UBOs e SSBOs não são suportados
* `sampler2D` é o único tipo de sampler suportado
* Apenas a versão de dois argumentos de `texture` (sampler e uv) é suportada
* Nenhuma entrada varying adicional pode ser declarada
* Todas as dicas de precisão são ignoradas ao direcionar Skia
* Inteiros sem sinal e booleanos não são suportados

### Uniforms

Um fragment program pode ser configurado definindo
valores `uniform` no código fonte do shader GLSL
e então definindo esses valores em Dart para
cada instância de fragment shader.

Uniforms de ponto flutuante com os tipos GLSL
`float`, `vec2`, `vec3` e `vec4`
são definidos usando o método [`FragmentShader.setFloat`][].
Valores de sampler GLSL, que usam o tipo `sampler2D`,
são definidos usando o método [`FragmentShader.setImageSampler`][].

O índice correto para cada valor `uniform` é determinado pela ordem
que os valores uniform são definidos no fragment program.
Para tipos de dados compostos por múltiplos floats, como um `vec4`,
você deve chamar [`FragmentShader.setFloat`][] uma vez para cada valor.

[`FragmentShader.setFloat`]: {{site.api}}/flutter/dart-ui/FragmentShader/setFloat.html
[`FragmentShader.setImageSampler`]: {{site.api}}/flutter/dart-ui/FragmentShader/setImageSampler.html

Por exemplo, dadas as seguintes declarações de uniforms em um fragment program GLSL:

```glsl
uniform float uScale;
uniform sampler2D uTexture;
uniform vec2 uMagnitude;
uniform vec4 uColor;
```

O código Dart correspondente para inicializar esses valores `uniform` é o seguinte:

```dart
void updateShader(FragmentShader shader, Color color, Image image) {
  shader.setFloat(0, 23);  // uScale
  shader.setFloat(1, 114); // uMagnitude x
  shader.setFloat(2, 83);  // uMagnitude y

  // Convert color to premultiplied opacity.
  shader.setFloat(3, color.red / 255 * color.opacity);   // uColor r
  shader.setFloat(4, color.green / 255 * color.opacity); // uColor g
  shader.setFloat(5, color.blue / 255 * color.opacity);  // uColor b
  shader.setFloat(6, color.opacity);                     // uColor a

  // Initialize sampler uniform.
  shader.setImageSampler(0, image);
 }
 ```

Observe que os índices usados com [`FragmentShader.setFloat`][]
não contam o uniform `sampler2D`.
Este uniform é definido separadamente com [`FragmentShader.setImageSampler`][],
com o índice começando novamente em 0.

Quaisquer uniforms float que forem deixados não inicializados terão o padrão de `0.0`.

#### Posição atual

O shader tem acesso a um valor `varying` que contém as coordenadas locais para
o fragmento específico sendo avaliado. Use esse recurso para calcular
efeitos que dependem da posição atual, que pode ser acessada
importando a biblioteca `flutter/runtime_effect.glsl` e chamando a
função `FlutterFragCoord`. Por exemplo:

```glsl
#include <flutter/runtime_effect.glsl>

void main() {
  vec2 currentPos = FlutterFragCoord().xy;
}
```

O valor retornado de `FlutterFragCoord` é distinto de `gl_FragCoord`.
`gl_FragCoord` fornece as coordenadas do espaço da tela e geralmente deve ser
evitado para garantir que os shaders sejam consistentes entre backends.
Ao direcionar um backend Skia,
as chamadas para `gl_FragCoord` são reescritas para acessar coordenadas
locais, mas essa reescrita não é possível com Impeller.

#### Cores

Não há um tipo de dados integrado para cores.
Em vez disso, elas são comumente representadas como um `vec4`
com cada componente correspondendo a um dos canais de cor
RGBA.

A única saída `fragColor` espera que o valor da cor
seja normalizado para estar no intervalo de `0.0` a `1.0`
e que tenha alfa pré-multiplicado.
Isso é diferente das cores típicas do Flutter que usam
uma codificação de valor `0-255` e têm alfa não pré-multiplicado.

#### Samplers

Um sampler fornece acesso a um objeto `Image` do `dart:ui`.
Esta imagem pode ser adquirida de uma imagem decodificada
ou de parte do aplicativo usando
[`Scene.toImageSync`][] ou [`Picture.toImageSync`][].

[`Picture.toImageSync`]: {{site.api}}/flutter/dart-ui/Picture/toImageSync.html
[`Scene.toImageSync`]: {{site.api}}/flutter/dart-ui/Scene/toImageSync.html

```glsl
#include <flutter/runtime_effect.glsl>

uniform vec2 uSize;
uniform sampler2D uTexture;

out vec4 fragColor;

void main() {
  vec2 uv = FlutterFragCoord().xy / uSize;
  fragColor = texture(uTexture, uv);
}
```

Por padrão, a imagem usa
[`TileMode.clamp`][] para determinar como os valores fora
do intervalo de `[0, 1]` se comportam.
A customização do tile mode não
é suportada e precisa ser emulada no shader.

[`TileMode.clamp`]: {{site.api}}/flutter/dart-ui/TileMode.html

### Considerações de desempenho

Ao direcionar o backend Skia,
carregar o shader pode ser caro, pois ele
deve ser compilado para o shader específico
da plataforma em tempo de execução.
Se você pretende usar um ou mais shaders durante uma animação,
considere pré-cachear os objetos fragment program antes
de iniciar a animação.

Você pode reutilizar um objeto `FragmentShader` entre frames;
isso é mais eficiente do que criar um novo
`FragmentShader` para cada frame.

Para um guia mais detalhado sobre como escrever shaders performáticos,
confira [Writing efficient shaders][] no GitHub.

[Writing efficient shaders]: {{site.repo.flutter}}/blob/main/engine/src/flutter/impeller/docs/shader_optimization.md

### Outros recursos

Para mais informações, aqui estão alguns recursos.

* [The Book of Shaders][] por Patricio Gonzalez Vivo e Jen Lowe
* [Shader toy][], um playground colaborativo de shaders
* [`simple_shader`][], um projeto de exemplo simples de fragment shaders Flutter
* [`flutter_shaders`][], um pacote que simplifica o uso de fragment shaders no Flutter

[Shader toy]: https://www.shadertoy.com/
[The Book of Shaders]: https://thebookofshaders.com/
[`simple_shader`]: {{site.repo.samples}}/tree/main/simple_shader
[`flutter_shaders`]: {{site.pub}}/packages/flutter_shaders
