---
ia-translate: true
title: Escrevendo e usando fragment shaders
description: Como criar e usar fragment shaders para criar efeitos visuais personalizados em seu app Flutter.
shortTitle: Fragment shaders
---

:::note
Os backends Skia e [Impeller][] suportam a escrita de um
shader personalizado. Exceto onde observado, as mesmas
instruções se aplicam aos dois.
:::

[Impeller]: /perf/impeller

Shaders personalizados podem ser usados para fornecer efeitos gráficos avançados
além dos fornecidos pelo SDK Flutter.
Um shader é um programa escrito em uma pequena
linguagem semelhante a Dart, conhecida como GLSL,
e executado na GPU do usuário.

Shaders personalizados são adicionados a um projeto Flutter
listando-os no arquivo `pubspec.yaml`,
e obtidos usando a API [`FragmentProgram`][].

[`FragmentProgram`]: {{site.api}}/flutter/dart-ui/FragmentProgram-class.html

## Adicionando shaders a um aplicativo

Shaders, na forma de arquivos GLSL com extensão `.frag`,
devem ser declarados na seção `shaders` do arquivo `pubspec.yaml` do seu projeto.
A ferramenta de linha de comando do Flutter compila o shader
para seu formato de backend apropriado,
e gera seus metadados de tempo de execução necessários.
O shader compilado é então incluído na aplicação como um ativo.

```yaml
flutter:
  shaders:
    - shaders/myshader.frag
```

Ao executar em modo debug,
as alterações em um programa shader acionam a recompilação
e atualizam o shader durante hot reload ou hot restart.

Shaders de pacotes são adicionados a um projeto
com `packages/$pkgname` prefixado ao nome do programa shader
(onde `$pkgname` é o nome do pacote).

### Carregando shaders em tempo de execução

Para carregar um shader em um objeto `FragmentProgram` em tempo de execução,
use o construtor [`FragmentProgram.fromAsset`][].
O nome do ativo é o mesmo que o caminho do shader
fornecido no arquivo `pubspec.yaml`.

[`FragmentProgram.fromAsset`]: {{site.api}}/flutter/dart-ui/FragmentProgram/fromAsset.html

```dart
void loadMyShader() async {
  var program = await FragmentProgram.fromAsset('shaders/myshader.frag');
}
```

O objeto `FragmentProgram` pode ser usado para criar
uma ou mais instâncias de [`FragmentShader`][].
Um objeto `FragmentShader` representa um programa de fragmento
juntamente com um conjunto particular de _uniforms_ (parâmetros de configuração).
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

Shaders de fragmento podem ser usados com a maioria das APIs Canvas
configurando [`Paint.shader`][].
Por exemplo, ao usar [`Canvas.drawRect`][]
o shader é avaliado para todos os fragmentos dentro do retângulo.
Para uma API como [`Canvas.drawPath`][] com um caminho traçado,
o shader é avaliado para todos os fragmentos dentro da linha traçada.
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

### API ImageFilter

Shaders de fragmento também podem ser usados com a API [`ImageFilter`][].
Isso permite usar shaders de fragmento personalizado com a
classe [`ImageFiltered`][] ou a classe [`BackdropFilter`][]
para aplicar shaders a conteúdo já renderizado.
[`ImageFilter`][] fornece um construtor, [`ImageFilter.shader`][],
para criar um [`ImageFilter`][] com um shader de fragmento personalizado.

```dart
Widget build(BuildContext context, FragmentShader shader) {
  return ClipRect(
    child: SizedBox(
      width: 300,
      height: 300,
      child: BackdropFilter(
        filter: ImageFilter.shader(shader),
        child: Container(
          color: Colors.transparent,
        ),
      ),
    ),
  );
}
```

Ao usar [`ImageFilter`][] com [`BackdropFilter`][], um [`ClipRect`][] pode ser
usado para limitar a área afetada pelo [`ImageFilter`][]. Sem um
[`ClipRect`][] o [`BackdropFilter`][] será aplicado a toda a tela.

Os shaders de fragmento `ImageFilter` recebem alguns uniforms automaticamente do
mecanismo. O valor `sampler2D` no índice 0 é definido como a imagem de entrada do filtro, e
os valores `float` nos índices 0 e 1 são definidos como a largura e altura da imagem.
Seu shader deve especificar este construtor para aceitar esses valores (por exemplo, um
`sampler2D` e um `vec2`), mas você não deve defini-los a partir do seu código Dart.

Ao direcionar OpenGLES, as coordenadas y da textura serão invertidas, portanto o
shader de fragmento deve desempenhar as UVs ao fazer amostragem de texturas fornecidas pelo
mecanismo.

```glsl
#version 460 core
#include <flutter/runtime_effect.glsl>

out vec4 fragColor;

// These uniforms are automatically set by the engine.
uniform vec2 u_size;
uniform sampler2D u_texture;

void main() {
  vec2 uv = FlutterFragCoord().xy / u_size;
#ifdef IMPELLER_TARGET_OPENGLES
  // When sampling from u_texture on OpenGLES the y-coordinates will be flipped.
  uv.y = 1.0 - uv.y;
#endif
  vec4 color = texture(u_texture, uv);
  float gray = dot(color.rgb, vec3(0.299, 0.587, 0.114));
  fragColor = vec4(vec3(gray), color.a);
}
```

[`ImageFilter`]: {{site.api}}/flutter/dart-ui/ImageFilter-class.html
[`ImageFiltered`]: {{site.api}}/flutter/widgets/ImageFiltered-class.html
[`BackdropFilter`]: {{site.api}}/flutter/widgets/BackdropFilter-class.html
[`ImageFilter.shader`]: {{site.api}}/flutter/dart-ui/ImageFilter/ImageFilter.shader.html
[`ClipRect`]: {{site.api}}/flutter/widgets/ClipRect-class.html

## Criando shaders

Shaders de fragmento são criados como arquivos de código-fonte GLSL.
Por convenção, esses arquivos têm a extensão `.frag`.
(Flutter não suporta shaders de vértice,
que teriam a extensão `.vert`.)

Qualquer versão GLSL de 460 até 100 é suportada,
embora alguns recursos disponíveis sejam restritos.
O resto dos exemplos neste documento usa a versão `460 core`.

Shaders estão sujeitos às seguintes limitações
quando usados com Flutter:

* UBOs e SSBOs não são suportados
* `sampler2D` é o único tipo de amostrador suportado
* Apenas a versão de dois argumentos de `texture` (amostrador e uv) é suportada
* Nenhuma entrada variável adicional pode ser declarada
* Todas as dicas de precisão são ignoradas ao direcionar Skia
* Inteiros não assinados e booleanos não são suportados

### Uniforms

Um programa de fragmento pode ser configurado definindo
valores `uniform` no código-fonte do shader GLSL
e então definindo esses valores em Dart para
cada instância de shader de fragmento.

Os uniformes de ponto flutuante com os tipos GLSL
`float`, `vec2`, `vec3` e `vec4`
são definidos usando o método [`FragmentShader.setFloat`][].
Os valores do amostrador GLSL, que usam o tipo `sampler2D`,
são definidos usando o método [`FragmentShader.setImageSampler`][].

O índice correto para cada valor `uniform` é determinado pela ordem
em que os valores uniformes são definidos no programa de fragmento.
Para tipos de dados compostos de múltiplos floats, como um `vec4`,
você deve chamar [`FragmentShader.setFloat`][] uma vez para cada valor.

[`FragmentShader.setFloat`]: {{site.api}}/flutter/dart-ui/FragmentShader/setFloat.html
[`FragmentShader.setImageSampler`]: {{site.api}}/flutter/dart-ui/FragmentShader/setImageSampler.html

Por exemplo, dadas as seguintes declarações uniformes em um programa de fragmento GLSL:

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

  // Converter cor para opacidade pré-multiplicada.
  shader.setFloat(3, color.red / 255 * color.opacity);   // uColor r
  shader.setFloat(4, color.green / 255 * color.opacity); // uColor g
  shader.setFloat(5, color.blue / 255 * color.opacity);  // uColor b
  shader.setFloat(6, color.opacity);                     // uColor a

  // Inicializar uniform de amostrador.
  shader.setImageSampler(0, image);
 }
 ```

Observe que os índices usados com [`FragmentShader.setFloat`][]
não contam com o uniform `sampler2D`.
Este uniform é definido separadamente com [`FragmentShader.setImageSampler`][],
com o índice começando do 0.

Qualquer uniforme de ponto flutuante que permanecer não inicializado será padrão para `0.0`.

Os dados de reflexão gerados pelo compilador de shader do Flutter podem ser auditados
com os seguintes comandos para ver coisas como deslocamentos uniformes.

```shell
cd $FLUTTER
# Gerar o arquivo .sl.
`find bin/ -name impellerc` \
  --runtime-stage-metal \
  --iplr \
  --input=path/to/myshader.frag \
  --sl=foo.sl \
  --spirv=foo.spirv \
  --include=engine/src/flutter/impeller/compiler/shader_lib/ \
  --input-type=frag
# Converter o arquivo .sl para .json
flatc \
  --json \
  ./engine/src/flutter/impeller/runtime_stage/runtime_stage.fbs \
  -- ./foo.sl
# Ver resultados
cat foo.json
```

#### Posição atual

O shader tem acesso a um valor `varying` que contém as coordenadas locais para
o fragmento particular sendo avaliado. Use este recurso para calcular
efeitos que dependem da posição atual, que podem ser acessados
importando a biblioteca `flutter/runtime_effect.glsl` e chamando a
função `FlutterFragCoord`. Por exemplo:

```glsl
#include <flutter/runtime_effect.glsl>

void main() {
  vec2 currentPos = FlutterFragCoord().xy;
}
```

O valor retornado de `FlutterFragCoord` é distinto de `gl_FragCoord`.
`gl_FragCoord` fornece as coordenadas do espaço de tela e geralmente deve ser
evitado para garantir que os shaders sejam consistentes entre backends.
Ao direcionar um backend Skia,
as chamadas para `gl_FragCoord` são reescritas para acessar
coordenadas locais, mas essa reescrita não é possível com Impeller.

#### Cores

Não há um tipo de dados integrado para cores.
Em vez disso, eles são comumente representados como um `vec4`
com cada componente correspondendo a um dos
canais de cor RGBA.

A saída única `fragColor` espera que o valor da cor
seja normalizado para estar no intervalo de `0.0` a `1.0`
e que tenha alfa pré-multiplicado.
Isso é diferente das cores Flutter típicas que usam
uma codificação de valor `0-255` e têm alfa não pré-multiplicado.

#### Amostradores

Um amostrador fornece acesso a um objeto `Image` `dart:ui`.
Esta imagem pode ser adquirida de uma imagem decodificada
ou de parte da aplicação usando
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
do intervalo `[0, 1]` se comportam.
A personalização do modo de mosaico não é
suportada e precisa ser emulada no shader.

[`TileMode.clamp`]: {{site.api}}/flutter/dart-ui/TileMode.html

### Considerações de desempenho

Ao direcionar o backend Skia,
carregar o shader pode ser custoso, pois deve
ser compilado para o shader apropriado
específico da plataforma em tempo de execução.
Se você pretender usar um ou mais shaders durante uma animação,
considere fazer cache dos objetos do programa de fragmento antes
de iniciar a animação.

Você pode reutilizar um objeto `FragmentShader` entre quadros;
isso é mais eficiente do que criar um novo
`FragmentShader` para cada quadro.

Para um guia mais detalhado sobre como escrever shaders eficientes,
confira [Escrevendo shaders eficientes][] no GitHub.

[Escrevendo shaders eficientes]: {{site.repo.flutter}}/blob/main/engine/src/flutter/impeller/docs/shader_optimization.md

### Outros recursos

Para mais informações, aqui estão alguns recursos.

* [The Book of Shaders][] por Patricio Gonzalez Vivo e Jen Lowe
* [Shader toy][], um playground de shader colaborativo
* [`simple_shader`][], um projeto de exemplo simples de shaders de fragmento do Flutter
* [`flutter_shaders`][], um pacote que simplifica o uso de shaders de fragmento no Flutter

[Shader toy]: https://www.shadertoy.com/
[The Book of Shaders]: https://thebookofshaders.com/
[`simple_shader`]: {{site.repo.samples}}/tree/main/simple_shader
[`flutter_shaders`]: {{site.pub}}/packages/flutter_shaders
