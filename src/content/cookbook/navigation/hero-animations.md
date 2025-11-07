---
title: Animar um widget entre telas
description: Como animar um widget de uma tela para outra
js:
  - defer: true
    url: /assets/js/inject_dartpad.js
ia-translate: true
---

<?code-excerpt path-base="cookbook/navigation/hero_animations"?>

Muitas vezes é útil guiar os usuários através de um app enquanto eles navegam de tela
para tela. Uma técnica comum para conduzir os usuários através de um app é animar um
widget de uma tela para a próxima. Isso cria uma âncora visual conectando
as duas telas.

Use o widget [`Hero`][]
para animar um widget de uma tela para a próxima.
Esta receita usa os seguintes passos:

  1. Criar duas telas mostrando a mesma imagem.
  2. Adicionar um widget `Hero` à primeira tela.
  3. Adicionar um widget `Hero` à segunda tela.

## 1. Criar duas telas mostrando a mesma imagem

Neste exemplo, exiba a mesma imagem em ambas as telas.
Anime a imagem da primeira tela para a segunda tela quando
o usuário tocar na imagem. Por enquanto, crie a estrutura visual;
lide com animações nos próximos passos.

:::note
Este exemplo se baseia nas receitas
[Navegar para uma nova tela e voltar][]
e [Lidar com toques][].
:::

<?code-excerpt "lib/main_original.dart"?>
```dart
import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Main Screen'),
      ),
      body: GestureDetector(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return const DetailScreen();
          }));
        },
        child: Image.network(
          'https://picsum.photos/250?image=9',
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
          child: Image.network(
            'https://picsum.photos/250?image=9',
          ),
        ),
      ),
    );
  }
}
```

## 2. Adicionar um widget `Hero` à primeira tela

Para conectar as duas telas juntas com uma animação, envolva
o widget `Image` em ambas as telas em um widget `Hero`.
O widget `Hero` requer dois argumentos:

`tag`
: Um objeto que identifica o `Hero`.
  Deve ser o mesmo em ambas as telas.

`child`
: O widget para animar entre telas.

{% comment %}
RegEx removes the first "child" property name and removed the trailing comma at the end
{% endcomment %}
<?code-excerpt "lib/main.dart (Hero1)" replace="/^child: //g;/^\),$/)/g"?>
```dart
Hero(
  tag: 'imageHero',
  child: Image.network(
    'https://picsum.photos/250?image=9',
  ),
)
```

## 3. Adicionar um widget `Hero` à segunda tela

Para completar a conexão com a primeira tela,
envolva a `Image` na segunda tela com um widget `Hero`
que tem a mesma `tag` do `Hero` na primeira tela.

Após aplicar o widget `Hero` à segunda tela,
a animação entre telas simplesmente funciona.

{% comment %}
RegEx removes the first "child" property name and removed the trailing comma at the end
{% endcomment %}
<?code-excerpt "lib/main.dart (Hero2)" replace="/^child: //g;/^\),$/)/g"?>
```dart
Hero(
  tag: 'imageHero',
  child: Image.network(
    'https://picsum.photos/250?image=9',
  ),
)
```


:::note
Este código é idêntico ao que você tem na primeira tela.
Como uma boa prática, crie um widget reutilizável em vez de
repetir código. Este exemplo usa código idêntico para ambos
widgets, por simplicidade.
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
    return const MaterialApp(
      title: 'Transition Demo',
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Main Screen'),
      ),
      body: GestureDetector(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return const DetailScreen();
          }));
        },
        child: Hero(
          tag: 'imageHero',
          child: Image.network(
            'https://picsum.photos/250?image=9',
          ),
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
            child: Image.network(
              'https://picsum.photos/250?image=9',
            ),
          ),
        ),
      ),
    );
  }
}
```

<noscript>
  <img src="/assets/images/docs/cookbook/hero.gif" alt="Hero demo" class="site-mobile-screenshot" />
</noscript>


[Lidar com toques]: /cookbook/gestures/handling-taps
[`Hero`]: {{site.api}}/flutter/widgets/Hero-class.html
[Navegar para uma nova tela e voltar]: /cookbook/navigation/navigation-basics
