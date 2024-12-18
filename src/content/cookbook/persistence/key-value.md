---
ia-translate: true
title: Armazenar dados de chave-valor em disco
description: >-
  Aprenda como usar o pacote shared_preferences para armazenar dados de chave-valor.
---

<?code-excerpt path-base="cookbook/persistence/key_value/"?>

Se você tem uma coleção relativamente pequena de chave-valores
para salvar, você pode usar o plugin [`shared_preferences`][].

Normalmente, você teria que
escrever integrações nativas de plataforma para armazenar dados em cada plataforma.
Felizmente, o plugin [`shared_preferences`][] pode ser usado para
persistir dados de chave-valor em disco em cada plataforma que o Flutter suporta.

Esta receita usa os seguintes passos:

  1. Adicionar a dependência.
  2. Salvar dados.
  3. Ler dados.
  4. Remover dados.

:::note
Para saber mais, assista a este vídeo curto do Pacote da Semana
sobre o pacote `shared_preferences`:

{% ytEmbed 'sa_U0jffQII', 'shared_preferences | Pacote da Semana do Flutter' %}
:::

## 1. Adicionar a dependência

Antes de começar, adicione o pacote [`shared_preferences`][] como uma dependência.

Para adicionar o pacote `shared_preferences` como uma dependência,
execute `flutter pub add`:

```console
flutter pub add shared_preferences
```

## 2. Salvar dados

Para persistir dados, use os métodos setter fornecidos pela
classe `SharedPreferences`. Métodos setter estão disponíveis para
vários tipos primitivos, como `setInt`, `setBool` e `setString`.

Métodos setter fazem duas coisas: Primeiro, atualizam sincronamente o
par chave-valor na memória. Então, persistem os dados em disco.

<?code-excerpt "lib/partial_excerpts.dart (Step2)"?>
```dart
// Carrega e obtém as preferências compartilhadas para este aplicativo.
final prefs = await SharedPreferences.getInstance();

// Salva o valor do contador no armazenamento persistente sob a chave 'counter'.
await prefs.setInt('counter', counter);
```

## 3. Ler dados

Para ler dados, use o método getter apropriado fornecido pela
classe `SharedPreferences`. Para cada setter, existe um getter correspondente.
Por exemplo, você pode usar os métodos `getInt`, `getBool` e `getString`.

<?code-excerpt "lib/partial_excerpts.dart (Step3)"?>
```dart
final prefs = await SharedPreferences.getInstance();

// Tenta ler o valor do contador do armazenamento persistente.
// Se não estiver presente, null é retornado, então o padrão é 0.
final counter = prefs.getInt('counter') ?? 0;
```

Observe que os métodos getter lançam uma exceção se o valor persistido
tiver um tipo diferente do que o método getter espera.

## 4. Remover dados

Para excluir dados, use o método `remove()`.

<?code-excerpt "lib/partial_excerpts.dart (Step4)"?>
```dart
final prefs = await SharedPreferences.getInstance();

// Remove o par chave-valor do contador do armazenamento persistente.
await prefs.remove('counter');
```

## Tipos suportados

Embora o armazenamento de chave-valor fornecido por `shared_preferences` seja
fácil e conveniente de usar, ele tem limitações:

* Apenas tipos primitivos podem ser usados: `int`, `double`, `bool`, `String`
  e `List<String>`.
* Não foi projetado para armazenar grandes quantidades de dados.
* Não há garantia de que os dados serão persistidos entre reinicializações do aplicativo.

## Suporte para testes

É uma boa ideia testar o código que persiste dados usando `shared_preferences`.
Para habilitar isso, o pacote fornece uma
implementação mock em memória do armazenamento de preferências.

Para configurar seus testes para usar a implementação mock,
chame o método estático `setMockInitialValues` em
um método `setUpAll()` em seus arquivos de teste.
Passe um mapa de pares chave-valor para usar como valores iniciais.

<?code-excerpt "test/prefs_test.dart (setup)"?>
```dart
SharedPreferences.setMockInitialValues(<String, Object>{
  'counter': 2,
});
```

## Exemplo completo

<?code-excerpt "lib/main.dart"?>
```dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Demonstração de preferências compartilhadas',
      home: MyHomePage(title: 'Demonstração de preferências compartilhadas'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  @override
  void initState() {
    super.initState();
    _loadCounter();
  }

  /// Carrega o valor inicial do contador do armazenamento persistente ao iniciar,
  /// ou retorna para 0 se ele não existir.
  Future<void> _loadCounter() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _counter = prefs.getInt('counter') ?? 0;
    });
  }

  /// Após um clique, incrementa o estado do contador e
  /// o salva assincronamente no armazenamento persistente.
  Future<void> _incrementCounter() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _counter = (prefs.getInt('counter') ?? 0) + 1;
      prefs.setInt('counter', _counter);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Você apertou o botão estas vezes:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Incrementar',
        child: const Icon(Icons.add),
      ),
    );
  }
}
```

[`shared_preferences`]: {{site.pub-pkg}}/shared_preferences
