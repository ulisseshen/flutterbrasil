---
ia-translate: true
title: Animar um widget entre telas
description: Como animar um widget de uma tela para outra
---

<?code-excerpt path-base="cookbook/navigation/hero_animations"?>

Frequentemente é útil guiar usuários através de um app enquanto eles navegam de tela
para tela. Uma técnica comum para conduzir usuários através de um app é animar um
widget de uma tela para a próxima. Isso cria uma âncora visual conectando
as duas telas.

Use o widget [`Hero`][`Hero`]
para animar um widget de uma tela para a próxima.
Esta receita usa os seguintes passos:

  1. Criar duas telas mostrando a mesma imagem.
  2. Adicionar um widget `Hero` à primeira tela.
  3. Adicionar um widget `Hero` à segunda tela.

## 1. Criar duas telas mostrando a mesma imagem

Neste exemplo, exiba a mesma imagem em ambas as telas.
Anime a imagem da primeira tela para a segunda tela quando
o usuário tocar na imagem. Por enquanto, crie a estrutura visual;
lidar com animações nos próximos passos.

:::note
Este exemplo se baseia nas receitas
[Navegar para uma nova tela e voltar][Navigate to a new screen and back]
e [Lidar com toques][Handle taps].
:::

<?code-excerpt "lib/main_original.dart"?>
```dart
import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Main Screen')),
      body: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder: (context) {
                return const DetailScreen();
              },
            ),
          );
        },
        child: Image.network('https://picsum.photos/250?image=9'),
      ),
    );
  }
}

class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Center(
          child: Image.network('https://picsum.photos/250?image=9'),
        ),
      ),
    );
  }
}
```

## 2. Adicionar um widget `Hero` à primeira tela

Para conectar as duas telas com uma animação, envolva
o widget `Image` em ambas as telas em um widget `Hero`.
O widget `Hero` requer dois argumentos:

`tag`
: Um objeto que identifica o `Hero`.
  Ele deve ser o mesmo em ambas as telas.

`child`
: O widget a ser animado entre telas.

{% comment %}
RegEx removes the first "child" property name and removed the trailing comma at the end
{% endcomment %}
<?code-excerpt "lib/main.dart (Hero1)" replace="/^child: //g;/^\),$/)/g"?>
```dart
Hero(
  tag: 'imageHero',
  child: Image.network('https://picsum.photos/250?image=9'),
)
```

## 3. Adicionar um widget `Hero` à segunda tela

Para completar a conexão com a primeira tela,
envolva o `Image` na segunda tela com um widget `Hero`
que tem a mesma `tag` do `Hero` na primeira tela.

Depois de aplicar o widget `Hero` à segunda tela,
a animação entre as telas simplesmente funciona.

{% comment %}
RegEx removes the first "child" property name and removed the trailing comma at the end
{% endcomment %}
<?code-excerpt "lib/main.dart (Hero2)" replace="/^child: //g;/^\),$/)/g"?>
```dart
Hero(
  tag: 'imageHero',
  child: Image.network('https://picsum.photos/250?image=9'),
)
```


:::note
Este código é idêntico ao que você tem na primeira tela.
Como boa prática, crie um widget reutilizável em vez de
repetir código. Este exemplo usa código idêntico para ambos
os widgets, por simplicidade.
:::

## Exemplo interativo

<?code-excerpt "lib/main.dart"?>
```dartpad title="Flutter Hero animation hands-on example in DartPad" run="true"
import 'package:flutter/material.dart';

void main() => runApp(const HeroApp());

class HeroApp extends StatelessWidget {
  const HeroApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(title: 'Transition Demo', home: MainScreen());
  }
}

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Main Screen')),
      body: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder: (context) {
                return const DetailScreen();
              },
            ),
          );
        },
        child: Hero(
          tag: 'imageHero',
          child: Image.network('https://picsum.photos/250?image=9'),
        ),
      ),
    );
  }
}

class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Center(
          child: Hero(
            tag: 'imageHero',
            child: Image.network('https://picsum.photos/250?image=9'),
          ),
        ),
      ),
    );
  }
}
```

<noscript>
  <img src="/assets/images/docs/cookbook/hero.webp" alt="Hero demo" class="site-mobile-screenshot" />
</noscript>


[Handle taps]: /cookbook/gestures/handling-taps
[`Hero`]: {{site.api}}/flutter/widgets/Hero-class.html
[Navigate to a new screen and back]: /cookbook/navigation/navigation-basics
