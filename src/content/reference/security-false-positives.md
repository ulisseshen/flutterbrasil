---
title: Falsos positivos de segurança
description: >-
  Vulnerabilidades de segurança reportadas incorretamente por
  ferramentas de análise estática automatizada.
showBreadcrumbs: false
ia-translate: true
---

## Introdução

Ocasionalmente recebemos relatos falsos de vulnerabilidades
de segurança em aplicações Dart e Flutter,
gerados por ferramentas que foram construídas para outros tipos
de aplicações (por exemplo, aquelas escritas com Java ou C++).
Este documento fornece informações sobre relatos que acreditamos
serem incorretos e explica por que as preocupações são equivocadas.

## Preocupações comuns

### Shared objects devem usar funções fortified

> The shared object does not have any fortified functions.
> Fortified functions provides buffer overflow checks against glibc's commons insecure functions like `strcpy`, `gets` etc.
> Use the compiler option `-D_FORTIFY_SOURCE=2` to fortify functions.

Quando isso se refere a código Dart compilado
(como o arquivo `libapp.so` em aplicações Flutter),
este conselho é equivocado porque o código Dart não
invoca diretamente funções libc;
todo código Dart passa pela biblioteca padrão do Dart.

(Em geral, MobSF obtém falsos positivos aqui porque
ele verifica qualquer uso de funções com um sufixo `_chk`,
mas como Dart não usa essas funções de forma alguma,
ele não tem chamadas com ou sem o sufixo,
e portanto MobSF trata o código como contendo
chamadas não-fortified.)

### Shared objects devem usar RELRO

> no RELRO found for `libapp.so` binaries

Dart não usa a Procedure Linkage Table
(PLT) normal ou mecanismos de Global Offsets Table (GOT) de forma alguma,
então a técnica Relocation Read-Only (RELRO) não
faz muito sentido para Dart.

O equivalente do Dart ao GOT é o pool pointer,
que ao contrário do GOT, está localizado em uma localização randomizada
e é, portanto, muito mais difícil de explorar.

Em princípio, você pode criar código vulnerável ao usar Dart FFI,
mas o uso normal do Dart FFI também não seria propenso a esses problemas,
assumindo que seja usado com código C que em si mesmo usa RELRO apropriadamente.

### Shared objects devem usar valores stack canary

> no canary are found for `libapp.so` binaries

> This shared object does not have a stack canary value added to the stack.
> Stack canaries are used to detect and prevent exploits from overwriting return address.
> Use the option -fstack-protector-all to enable stack canaries.

Dart não gera stack canaries porque,
ao contrário do C++, Dart não tem arrays alocados na stack
(a principal fonte de stack smashing em C/C++).

Ao escrever Dart puro (sem usar `dart:ffi`),
você já tem garantias de isolamento muito mais fortes
do que qualquer mitigação C++ pode fornecer,
simplesmente porque código Dart puro é uma linguagem gerenciada
onde coisas como buffer overruns não existem.

Em princípio, você pode criar código vulnerável ao usar Dart FFI,
mas o uso normal do Dart FFI também não seria propenso a esses problemas,
assumindo que seja usado com código C que em si mesmo usa valores stack canary
apropriadamente.

### Código deve evitar usar as APIs `_sscanf`, `_strlen`, e `_fopen`

> The binary may contain the following insecure API(s) `_sscanf` , `_strlen` , `_fopen`.

As ferramentas que relatam esses problemas tendem a ser
excessivamente simplistas em suas varreduras;
por exemplo, encontrando funções personalizadas com
esses nomes e assumindo que elas se referem às
funções da biblioteca padrão.
Muitas das dependências de terceiros do Flutter têm
funções com nomes similares que disparam essas verificações.
É possível que algumas ocorrências sejam preocupações válidas,
mas é impossível dizer pela saída dessas ferramentas
devido ao enorme número de falsos positivos.

### Código deve usar `calloc` (em vez de `_malloc`) para alocações de memória

> The binary may use `_malloc` function instead of `calloc`.

Alocação de memória é um tópico com nuances,
onde trade-offs têm que ser feitos entre desempenho
e resiliência a vulnerabilidades.
Meramente usar `malloc` não é automaticamente indicativo
de uma vulnerabilidade de segurança.
Embora aceitemos relatos concretos (veja abaixo)
para casos onde usar `calloc` seria preferível,
na prática seria inapropriado uniformemente
substituir todas as chamadas `malloc` por `calloc`.

### O binário iOS tem um Runpath Search Path (`@rpath`) definido

> The binary has Runpath Search Path (`@rpath`) set.
> In certain cases an attacker can abuse this feature to run arbitrary executable for code execution and privilege escalation.
> Remove the compiler option `-rpath` to remove `@rpath`.

Quando o app está sendo compilado, Runpath Search Path refere-se
aos caminhos que o linker busca para encontrar bibliotecas dinâmicas
(dylibs) usadas pelo app.
Por padrão, apps iOS têm isso definido como
`@executable_path/Frameworks`,
o que significa que o linker deve buscar dylibs
no diretório `Frameworks` relativo ao binário
do app dentro do bundle do app.
O engine `Flutter.framework`,
como a maioria dos frameworks ou dylibs incorporados,
é copiado corretamente para este diretório.
Quando o app é executado, ele carrega o binário da biblioteca.

Apps Flutter usam a configuração de build iOS padrão
(`LD_RUNPATH_SEARCH_PATHS=@executable_path/Frameworks`).

Vulnerabilidades envolvendo `@rpath` não se aplicam
em configurações mobile, pois atacantes não têm
acesso ao sistema de arquivos e não podem arbitrariamente
trocar esses frameworks.
Mesmo que um atacante de alguma forma _pudesse_ trocar o
framework por um malicioso,
o app crasharia na inicialização devido a violações de codesigning.

### Vulnerabilidade CBC with PKCS5/PKCS7 padding

Recebemos relatos vagos de que existe uma
"vulnerabilidade CBC with PKCS5/PKCS7 padding"
em alguns packages Flutter.

Pelo que podemos dizer, isso é disparado pela implementação HLS
no ExoPlayer
(a classe `com.google.android.exoplayer2.source.hls.Aes128DataSource`).
HLS é o formato de streaming da Apple,
que define o tipo de criptografia que deve ser usado para DRM;
isso não é uma vulnerabilidade,
pois DRM não protege a máquina ou dados do usuário
mas em vez disso meramente fornece ofuscação
para limitar a capacidade do usuário de usar completamente seu software e hardware.

### Apps podem ler e escrever no armazenamento externo

> App can read/write to External Storage. Any App can read data written to External Storage.

> As with data from any untrusted source, you should perform input validation when handling data from external storage.
> We strongly recommend that you not store executables or class files on external storage prior to dynamic loading.
> If your app does retrieve executable files from external storage,
> the files should be signed and cryptographically verified prior to dynamic loading.

Recebemos relatos de que algumas ferramentas
de varredura de vulnerabilidades interpretam a capacidade de plugins
de seleção de imagens de ler e escrever no armazenamento externo como uma ameaça.

Ler imagens do armazenamento local é o propósito desses plugins;
isso não é uma vulnerabilidade.

### Apps deletam dados usando file.delete()

> When you delete a file using file. delete, only the reference to the file is removed from the file system table.
> The file still exists on disk until other data overwrites it, leaving it vulnerable to recovery.

Algumas ferramentas de varredura de vulnerabilidades interpretam a exclusão de
arquivos temporários depois que um plugin de câmera registra dados da
câmera do dispositivo como uma vulnerabilidade de segurança.
Como o vídeo é gravado pelo usuário e armazenado
no hardware do usuário, não há risco real.

## Preocupações obsoletas

Esta seção contém mensagens válidas que podem ser vistas com
versões mais antigas de Dart e Flutter, mas não devem mais
ser vistas com versões mais recentes.
Se você ver essas mensagens com versões antigas de Dart ou Flutter,
atualize para a versão estável mais recente.
Se você ver essas com a versão estável atual,
por favor relate-as (veja a seção no final deste documento).

### A stack deve ter seu bit NX definido

> The shared object does not have NX bit set.
> NX bit offer protection against exploitation of memory corruption vulnerabilities by marking memory page as non-executable.
> Use option `--noexecstack` or `-z noexecstack` to mark stack as non executable.

(A mensagem do MobSF é enganosa; ela está procurando
se a stack está marcada como não-executável,
não o shared object.)

Em versões mais antigas de Dart e Flutter havia um bug
onde o gerador ELF não emitia o segmento `gnustack`
com a permissão `~X`, mas isso agora está corrigido.

## Relatando preocupações reais

Embora ferramentas de varredura de vulnerabilidades automatizadas relatem
falsos positivos como os exemplos acima,
não podemos descartar que existem problemas reais que
merecem atenção mais próxima.
Se você encontrar um problema que acredita ser uma
vulnerabilidade de segurança legítima, agradeceremos muito
se você reportá-la:

* [Política de segurança do Flutter](/security)
* [Política de segurança do Dart]({{site.dart-site}}/security)
