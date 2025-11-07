---
ia-translate: true
title: Falsos positivos de segurança
description: Vulnerabilidades de segurança relatadas incorretamente por ferramentas de análise estática automatizada
---

## Introdução

Ocasionalmente recebemos relatórios falsos de vulnerabilidades
de segurança em aplicações Dart e Flutter,
gerados por ferramentas que foram construídas para outros tipos
de aplicações (por exemplo, aquelas escritas com Java ou C++).
Este documento fornece informações sobre relatórios que acreditamos
estarem incorretos e explica por que as preocupações são equivocadas.

## Preocupações comuns

### Objetos compartilhados devem usar funções fortificadas

> O objeto compartilhado não possui nenhuma função fortificada.
> Funções fortificadas fornecem verificações de buffer overflow contra funções inseguras comuns da glibc como `strcpy`, `gets` etc.
> Use a opção do compilador `-D_FORTIFY_SOURCE=2` para fortificar funções.

Quando isso se refere ao código Dart compilado
(como o arquivo `libapp.so` em aplicações Flutter),
este conselho é equivocado porque o código Dart não
invoca diretamente funções libc;
todo código Dart passa pela biblioteca padrão do Dart.

(Em geral, o MobSF obtém falsos positivos aqui porque
ele verifica qualquer uso de funções com sufixo `_chk`,
mas como o Dart não usa essas funções de forma alguma,
ele não possui chamadas com ou sem o sufixo,
e portanto o MobSF trata o código como contendo
chamadas não fortificadas.)

### Objetos compartilhados devem usar RELRO

> nenhum RELRO encontrado para binários `libapp.so`

O Dart não usa os mecanismos normais de Procedure Linkage Table
(PLT) ou Global Offsets Table (GOT) de forma alguma,
então a técnica Relocation Read-Only (RELRO) realmente não
faz muito sentido para o Dart.

O equivalente do Dart para o GOT é o pool pointer,
que ao contrário do GOT, está localizado em um local randomizado
e portanto é muito mais difícil de explorar.

Em princípio, você pode criar código vulnerável ao usar Dart FFI,
mas o uso normal do Dart FFI não seria propenso a esses problemas também,
assumindo que seja usado com código C que em si usa RELRO adequadamente.

### Objetos compartilhados devem usar valores de canário de pilha

> nenhum canário encontrado para binários `libapp.so`

> Este objeto compartilhado não possui um valor de canário de pilha adicionado à pilha.
> Canários de pilha são usados para detectar e prevenir exploits que sobrescrevem o endereço de retorno.
> Use a opção -fstack-protector-all para habilitar canários de pilha.

O Dart não gera canários de pilha porque,
ao contrário do C++, o Dart não possui arrays alocados em pilha
(a fonte primária de stack smashing em C/C++).

Ao escrever Dart puro (sem usar `dart:ffi`),
você já tem garantias de isolamento muito mais fortes
do que qualquer mitigação de C++ pode fornecer,
simplesmente porque código Dart puro é uma linguagem gerenciada
onde coisas como buffer overruns não existem.

Em princípio, você pode criar código vulnerável ao usar Dart FFI,
mas o uso normal do Dart FFI não seria propenso a esses problemas também,
assumindo que seja usado com código C que em si usa valores de canário de pilha
adequadamente.

### O código deve evitar usar as APIs `_sscanf`, `_strlen` e `_fopen`

> O binário pode conter as seguintes API(s) inseguras `_sscanf` , `_strlen` , `_fopen`.

As ferramentas que relatam esses problemas tendem a ser
excessivamente simplistas em suas varreduras;
por exemplo, encontrando funções personalizadas com
esses nomes e assumindo que elas se referem às
funções da biblioteca padrão.
Muitas das dependências de terceiros do Flutter possuem
funções com nomes similares que acionam essas verificações.
É possível que algumas ocorrências sejam preocupações válidas,
mas é impossível dizer a partir da saída dessas ferramentas
devido ao grande número de falsos positivos.

### O código deve usar `calloc` (em vez de `_malloc`) para alocações de memória

> O binário pode usar a função `_malloc` em vez de `calloc`.

Alocação de memória é um tópico com nuances,
onde compromissos devem ser feitos entre desempenho
e resiliência a vulnerabilidades.
Meramente usar `malloc` não é automaticamente indicativo
de uma vulnerabilidade de segurança.
Embora aceitemos relatórios concretos (veja abaixo)
para casos onde usar `calloc` seria preferível,
na prática seria inadequado uniformemente
substituir todas as chamadas `malloc` por `calloc`.

### O binário iOS tem um Runpath Search Path (`@rpath`) definido

> O binário tem Runpath Search Path (`@rpath`) definido.
> Em certos casos um atacante pode abusar deste recurso para executar executável arbitrário para execução de código e escalação de privilégios.
> Remova a opção do compilador `-rpath` para remover `@rpath`.

Quando o app está sendo compilado, Runpath Search Path se refere
aos caminhos que o linker busca para encontrar bibliotecas dinâmicas
(dylibs) usadas pelo app.
Por padrão, apps iOS têm isso definido para
`@executable_path/Frameworks`,
o que significa que o linker deve buscar dylibs
no diretório `Frameworks` relativo ao binário
do app dentro do app bundle.
A engine `Flutter.framework`,
como a maioria dos frameworks ou dylibs incorporados,
é corretamente copiada para este diretório.
Quando o app é executado, ele carrega o binário da biblioteca.

Apps Flutter usam a configuração padrão de build do iOS
(`LD_RUNPATH_SEARCH_PATHS=@executable_path/Frameworks`).

Vulnerabilidades envolvendo `@rpath` não se aplicam
em configurações mobile, pois atacantes não têm
acesso ao sistema de arquivos e não podem arbitrariamente
trocar esses frameworks.
Mesmo se um atacante de alguma forma _pudesse_ trocar o
framework por um malicioso,
o app travaria na inicialização devido a violações de codesigning.

### Vulnerabilidade de padding CBC com PKCS5/PKCS7

Recebemos relatórios vagos de que existe uma
"vulnerabilidade de padding CBC com PKCS5/PKCS7"
em alguns packages Flutter.

Pelo que podemos dizer, isso é acionado pela implementação
HLS no ExoPlayer
(a classe `com.google.android.exoplayer2.source.hls.Aes128DataSource`).
HLS é o formato de streaming da Apple,
que define o tipo de criptografia que deve ser usada para DRM;
isso não é uma vulnerabilidade,
pois o DRM não protege a máquina ou dados do usuário
mas em vez disso meramente fornece ofuscação
para limitar a capacidade do usuário de usar totalmente seu software e hardware.

### Apps podem ler e escrever em armazenamento externo

> App pode ler/escrever em Armazenamento Externo. Qualquer App pode ler dados escritos em Armazenamento Externo.

> Assim como com dados de qualquer fonte não confiável, você deve realizar validação de entrada ao manipular dados de armazenamento externo.
> Recomendamos fortemente que você não armazene executáveis ou arquivos de classe em armazenamento externo antes de carregamento dinâmico.
> Se seu app recupera arquivos executáveis de armazenamento externo,
> os arquivos devem ser assinados e verificados criptograficamente antes do carregamento dinâmico.

Recebemos relatórios de que algumas ferramentas de
varredura de vulnerabilidades interpretam a capacidade de plugins
de seleção de imagens de ler e escrever em armazenamento externo como uma ameaça.

Ler imagens do armazenamento local é o propósito desses plugins;
isso não é uma vulnerabilidade.

### Apps deletam dados usando file.delete()

> Quando você deleta um arquivo usando file.delete, apenas a referência ao arquivo é removida da tabela do sistema de arquivos.
> O arquivo ainda existe no disco até que outros dados o sobrescrevam, deixando-o vulnerável à recuperação.

Algumas ferramentas de varredura de vulnerabilidades interpretam a exclusão de
arquivos temporários depois que um plugin de câmera grava dados da
câmera do dispositivo como uma vulnerabilidade de segurança.
Como o vídeo é gravado pelo usuário e é armazenado
no hardware do usuário, não há risco real.

## Preocupações obsoletas

Esta seção contém mensagens válidas que podem ser vistas com
versões mais antigas do Dart e Flutter, mas não devem mais
ser vistas com versões mais recentes.
Se você ver essas mensagens com versões antigas do Dart ou Flutter,
atualize para a versão estável mais recente.
Se você vê-las com a versão estável atual,
por favor reporte-as (veja a seção no final deste documento).

### A pilha deve ter seu bit NX definido

> O objeto compartilhado não possui bit NX definido.
> O bit NX oferece proteção contra exploração de vulnerabilidades de corrupção de memória marcando a página de memória como não executável.
> Use a opção `--noexecstack` ou `-z noexecstack` para marcar a pilha como não executável.

(A mensagem do MobSF é enganosa; ela está procurando
se a pilha está marcada como não executável,
não o objeto compartilhado.)

Em versões mais antigas do Dart e Flutter havia um bug
onde o gerador ELF não emitia o segmento `gnustack`
com a permissão `~X`, mas isso agora está corrigido.

## Relatando preocupações reais

Embora ferramentas de varredura de vulnerabilidades automatizadas relatem
falsos positivos como os exemplos acima,
não podemos descartar que existam problemas reais que
merecem atenção mais detalhada.
Se você encontrar um problema que acredita ser uma
vulnerabilidade de segurança legítima, agradeceremos muito
se você o reportar:

* [Flutter security policy](/security)
* [Dart security policy]({{site.dart-site}}/security)
