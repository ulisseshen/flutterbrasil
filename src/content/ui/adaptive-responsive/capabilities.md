---
ia-translate: true
title: Capacidades e políticas
description: >-
  Aprenda como adaptar seu aplicativo às
  capacidades e políticas exigidas pela
  plataforma, loja de aplicativos, sua empresa,
  e assim por diante.
---

A maioria dos aplicativos do mundo real precisa se adaptar às
capacidades e políticas de diferentes dispositivos e plataformas.
Esta página contém conselhos sobre como
lidar com esses cenários em seu código.

## Projete com base nos pontos fortes de cada tipo de dispositivo

Considere os pontos fortes e fracos exclusivos de diferentes dispositivos.
Além do tamanho da tela e das entradas, como toque, mouse, teclado,
quais outros recursos exclusivos você pode aproveitar?
O Flutter permite que seu código _execute_ em diferentes dispositivos,
mas um design forte é mais do que apenas executar código.
Pense no que cada plataforma faz de melhor e
veja se há recursos exclusivos para aproveitar.

Por exemplo: a App Store da Apple e a Play Store do Google
têm regras diferentes que os aplicativos precisam seguir.
Diferentes sistemas operacionais host têm diferentes
capacidades ao longo do tempo, bem como entre si.

Outro exemplo é aproveitar a barreira extremamente
baixa da web para compartilhamento. Se você estiver implantando um aplicativo da web,
decida quais links diretos oferecer suporte,
e projete as rotas de navegação tendo isso em mente.

O padrão recomendado do Flutter para lidar com
comportamentos diferentes com base nesses recursos exclusivos
é criar um conjunto de classes `Capability` e `Policy` para seu aplicativo.

### Capabilities

Uma _capability_ define o que o código ou dispositivo _pode_ fazer.
Exemplos de capabilities incluem:

* A existência de uma API
* Restrições impostas pelo SO
* Requisitos de hardware físico (como uma câmera)

### Policies

Uma _policy_ define o que o código _deve_ fazer.

Exemplos de policies incluem:

* Diretrizes da loja de aplicativos
* Preferências de design
* Ativos ou cópias que se referem ao dispositivo host
* Recursos habilitados no lado do servidor

### Como estruturar o código de policy

A maneira mecânica mais simples é `Platform.isAndroid`,
`Platform.isIOS` e `kIsWeb`. Essas APIs mecanicamente
permitem que você saiba onde o código está sendo executado, mas têm alguns
problemas à medida que o aplicativo se expande onde pode ser executado e
à medida que as plataformas host adicionam funcionalidades.

As diretrizes a seguir explicam as melhores práticas
ao desenvolver capabilities e policies para seu aplicativo:

**Evite usar `Platform.isAndroid` e funções semelhantes
para tomar decisões de layout ou fazer suposições sobre o que um dispositivo pode fazer.**

Em vez disso, descreva em qual ramificação você deseja entrar em um método.

Exemplo: seu aplicativo tem um link para comprar algo em um
site, mas você não quer mostrar esse link em dispositivos iOS
por motivos de policy.

```dart
bool shouldAllowPurchaseClick() {
  // Proibido pelas diretrizes da Apple App Store.
  return !Platform.isIOS;
}

...
TextSpan(
  text: 'Comprar no navegador',
  style: new TextStyle(color: Colors.blue),
  recognizer: shouldAllowPurchaseClick ? TapGestureRecognizer()
    ..onTap = () { launch('<alguma url>') : null;
  } : null,
```

O que você obteve ao adicionar uma camada adicional de indireção?
O código deixa mais claro o motivo da existência do caminho ramificado.
Este método pode existir diretamente na classe, mas é provável
que outras partes do código precisem da mesma verificação.
Se sim, coloque o código em uma classe.

```dart title="policy.dart"

class Policy {

  bool shouldAllowPurchaseClick() {
    // Proibido pelas diretrizes da Apple App Store.
    return !Platform.isIOS;
  }
}
```

Com este código em uma classe, qualquer teste de widget pode simular
`Policy().shouldAllowPurchaseClick` e verificar o comportamento
independentemente de onde o dispositivo é executado.
Também significa que, mais tarde, se você decidir que
comprar na web não é o fluxo certo para
usuários Android, você pode alterar a implementação
e os testes para texto clicável não precisarão ser alterados.

## Capabilities

Às vezes, você quer que seu código faça algo, mas a
API não existe, ou talvez você dependa de um recurso de plugin
que ainda não foi implementado em todas as plataformas que você oferece suporte.
Esta é uma limitação do que o dispositivo _pode_ fazer.

Essas situações são semelhantes às decisões de policy
descritas acima, mas são chamadas de _capabilities_.
Por que separar as classes de policy das capabilities
quando a estrutura das classes é semelhante?
A equipe do Flutter descobriu com aplicativos produzidos que fazer
uma distinção lógica entre o que os aplicativos _podem_ fazer e
o que eles _devem_ fazer ajuda produtos maiores a responder a
alterações no que as plataformas podem fazer ou exigir
além de suas próprias preferências depois que
o código inicial é escrito.

Por exemplo, considere o caso em que uma plataforma adiciona
uma nova permissão que exige que os usuários interajam com
uma caixa de diálogo do sistema antes que seu código chame uma API confidencial.
Sua equipe faz o trabalho para a plataforma 1 e cria uma
capability chamada `requirePermissionDialogFlow`.
Então, se e quando a plataforma 2 adicionar um requisito semelhante
mas apenas para novas versões da API,
a implementação de `requirePermissionDialogFlow`
agora pode verificar o nível da API e retornar true para a plataforma 2.
Você aproveitou o trabalho que já fez.

## Policies

Incentivamos você a começar com uma classe `Policy` inicialmente,
mesmo que pareça que você não tomará muitas decisões baseadas em policy.
À medida que a complexidade da classe aumenta ou o número de entradas aumenta,
você pode decidir dividir a classe de policy por recurso
ou algum outro critério.

Para a implementação de policy, você pode usar o tempo de compilação,
tempo de execução ou implementações baseadas em Remote Procedure Call (RPC).

As verificações de policy em tempo de compilação são boas para plataformas
onde é improvável que a preferência mude e onde
mudar acidentalmente o valor pode ter grandes consequências.
Por exemplo, se uma plataforma exige que você não
vincule à Play Store ou exige que você use
um provedor de pagamento específico, dado o conteúdo do seu aplicativo.

As verificações em tempo de execução podem ser boas para determinar se existe
uma tela sensível ao toque que o usuário possa usar. O Android tem um recurso
que você pode verificar e sua implementação na web pode
verificar o número máximo de pontos de toque.

As alterações de policy baseadas em RPC são boas para
o lançamento gradual de recursos ou para decisões que podem mudar mais tarde.

## Resumo

Use uma classe `Capability` para definir o que o código *pode* fazer.
Você pode verificar a existência de uma API,
restrições impostas pelo sistema operacional
e requisitos de hardware físico (como uma câmera).
Uma capability geralmente envolve verificações de compilação ou tempo de execução.

Use uma classe `Policy` (ou classes, dependendo da complexidade)
para definir o que o código _deve_ fazer para cumprir
as diretrizes da loja de aplicativos, preferências de design
e ativos ou cópias que precisam se referir ao dispositivo host.
As policies podem ser uma combinação de verificações de compilação, tempo de execução ou RPC.

Teste o código de ramificação simulando capabilities e
policies para que os testes de widget não precisem ser alterados
quando capabilities ou policies mudarem.

Nomeie os métodos em suas classes de capabilities e policies
com base no que eles estão tentando ramificar, em vez de no tipo de dispositivo.
