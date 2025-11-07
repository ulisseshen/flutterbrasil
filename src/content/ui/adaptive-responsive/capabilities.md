---
ia-translate: true
title: Capacidades e políticas
description: >-
  Aprenda como adaptar seu app às
  capacidades e políticas exigidas
  pela plataforma, loja de aplicativos, sua empresa,
  e assim por diante.
---

A maioria dos apps do mundo real tem a necessidade de se adaptar às
capacidades e políticas de diferentes dispositivos e plataformas.
Esta página contém conselhos sobre como
lidar com esses cenários em seu código.

## Projete para os pontos fortes de cada tipo de dispositivo

Considere os pontos fortes e fracos únicos de diferentes dispositivos.
Além de seu tamanho de tela e entradas, como toque, mouse, teclado,
quais outras capacidades únicas você pode aproveitar?
O Flutter permite que seu código _rode_ em diferentes dispositivos,
mas um design forte é mais do que apenas rodar código.
Pense sobre o que cada plataforma faz de melhor e
veja se há capacidades únicas para aproveitar.

Por exemplo: a App Store da Apple e a Play Store do Google
têm regras diferentes que os apps precisam seguir.
Diferentes sistemas operacionais host têm
capacidades diferentes ao longo do tempo, bem como entre si.

Outro exemplo é aproveitar a barreira extremamente
baixa da web para compartilhamento. Se você está implantando um app web,
decida quais deep links suportar,
e projete as rotas de navegação com isso em mente.

O padrão recomendado pelo Flutter para lidar com comportamento
diferente com base nessas capacidades únicas é criar
um conjunto de classes `Capability` e `Policy` para seu app.

### Capacidades

Uma _capacidade_ define o que o código ou dispositivo _pode_ fazer.
Exemplos de capacidades incluem:

* A existência de uma API
* Restrições impostas pelo SO
* Requisitos de hardware físico (como uma câmera)

### Políticas

Uma _política_ define o que o código _deve_ fazer.

Exemplos de políticas incluem:

* Diretrizes da loja de aplicativos
* Preferências de design
* Recursos ou texto que se refere ao dispositivo host
* Funcionalidades habilitadas no lado do servidor

### Como estruturar o código de política

A maneira mecânica mais simples é `Platform.isAndroid`,
`Platform.isIOS` e `kIsWeb`. Essas APIs mecanicamente
permitem que você saiba onde o código está sendo executado, mas têm alguns
problemas à medida que o app se expande onde pode rodar, e
à medida que as plataformas host adicionam funcionalidade.

As seguintes diretrizes explicam as melhores práticas
ao desenvolver as capacidades e políticas para seu app:

**Evite usar `Platform.isAndroid` e funções similares
para tomar decisões de layout ou suposições sobre o que um dispositivo pode fazer.**

Em vez disso, descreva sobre o que você quer ramificar em um método.

Exemplo: Seu app tem um link para comprar algo em um
site, mas você não quer mostrar esse link em dispositivos
iOS por razões de política.

```dart
bool shouldAllowPurchaseClick() {
  // Banned by Apple App Store guidelines.
  return !Platform.isIOS;
}

...
TextSpan(
  text: 'Buy in browser',
  style: new TextStyle(color: Colors.blue),
  recognizer: shouldAllowPurchaseClick ? TapGestureRecognizer()
    ..onTap = () { launch('<some url>') : null;
  } : null,
```

O que você ganhou ao adicionar uma camada adicional de indireção?
O código deixa mais claro por que o caminho ramificado existe.
Este método pode existir diretamente na classe, mas é provável
que outras partes do código possam precisar desta mesma verificação.
Se sim, coloque o código em uma classe.

```dart title="policy.dart"

class Policy {

  bool shouldAllowPurchaseClick() {
    // Banned by Apple App Store guidelines.
    return !Platform.isIOS;
  }
}
```

Com este código em uma classe, qualquer teste de widget pode fazer mock
de `Policy().shouldAllowPurchaseClick` e verificar o comportamento
independentemente de onde o dispositivo é executado.
Isso também significa que mais tarde, se você decidir que
comprar na web não é o fluxo certo para
usuários Android, você pode mudar a implementação
e os testes para texto clicável não precisarão mudar.

## Capacidades

Às vezes você quer que seu código faça algo, mas a
API não existe, ou talvez você dependa de um recurso de plugin
que ainda não está implementado em todas as plataformas que você suporta.
Esta é uma limitação do que o dispositivo _pode_ fazer.

Essas situações são semelhantes às decisões de política
descritas acima, mas são referidas como _capacidades_.
Por que separar classes de política de capacidades
quando a estrutura das classes é semelhante?
A equipe Flutter descobriu com apps em produção que fazer
uma distinção lógica entre o que os apps _podem_ fazer e
o que eles _devem_ fazer ajuda produtos maiores a responder a
mudanças no que as plataformas podem fazer ou exigir
além de suas próprias preferências após
o código inicial ser escrito.

Por exemplo, considere o caso em que uma plataforma adiciona
uma nova permissão que exige que os usuários interajam com
um diálogo do sistema antes que seu código chame uma API sensível.
Sua equipe faz o trabalho para a plataforma 1 e cria uma
capacidade chamada `requirePermissionDialogFlow`.
Então, se e quando a plataforma 2 adicionar um requisito semelhante
mas apenas para novas versões de API,
então a implementação de `requirePermissionDialogFlow`
pode agora verificar o nível de API e retornar true para a plataforma 2.
Você aproveitou o trabalho que já fez.

## Políticas

Encorajamos começar com uma classe `Policy` inicialmente
mesmo que pareça que você não vai tomar muitas decisões baseadas em políticas.
À medida que a complexidade da classe cresce ou o número de entradas se expande,
você pode decidir dividir a classe de política por recurso
ou algum outro critério.

Para implementação de políticas, você pode usar tempo de compilação,
tempo de execução ou implementações baseadas em Remote Procedure Call (RPC).

Verificações de política em tempo de compilação são boas para plataformas
onde a preferência é improvável de mudar e onde
mudar acidentalmente o valor pode ter grandes consequências.
Por exemplo, se uma plataforma exige que você não
faça link para a Play Store, ou exige que você use
um provedor de pagamento específico dado o conteúdo do seu app.

Verificações em tempo de execução podem ser boas para determinar se há
uma tela sensível ao toque que o usuário pode usar. O Android tem um recurso
que você pode verificar e sua implementação web poderia
verificar o máximo de pontos de toque.

Mudanças de política baseadas em RPC são boas para
lançamento incremental de recursos ou para decisões que podem mudar depois.

## Resumo

Use uma classe `Capability` para definir o que o código *pode* fazer.
Você pode verificar a existência de uma API,
restrições impostas pelo SO,
e requisitos de hardware físico (como uma câmera).
Uma capacidade geralmente envolve verificações em tempo de compilação ou execução.

Use uma classe `Policy` (ou classes dependendo da complexidade)
para definir o que o código _deve_ fazer para cumprir com
diretrizes da loja de aplicativos, preferências de design,
e recursos ou texto que precisam se referir ao dispositivo host.
Políticas podem ser uma mistura de verificações em tempo de compilação, execução ou RPC.

Teste o código de ramificação fazendo mock de capacidades e
políticas para que os testes de widget não precisem mudar
quando capacidades ou políticas mudarem.

Nomeie os métodos em suas classes de capacidades e políticas
com base no que eles estão tentando ramificar, em vez de no tipo de dispositivo.
