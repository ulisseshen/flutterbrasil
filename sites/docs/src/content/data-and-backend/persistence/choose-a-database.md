---
ia-translate: true
title: Escolha um banco de dados para o seu app Flutter
shortTitle: Escolha um banco de dados
description: >-
  Compare Cloud Firestore, Firebase SQL Connect, SQLite e armazenamento chave-valor
  para escolher o banco de dados certo para o seu app Flutter.
---

O Flutter não inclui um banco de dados integrado, então você pode escolher um
com base no formato dos seus dados e em onde eles precisam ficar.
Para a maioria dos apps Flutter, comece com uma destas opções:

* **Cloud Firestore** para dados NoSQL escaláveis que
  sincronizam entre dispositivos em tempo real.
* **Firebase SQL Connect** para dados relacionais que
  precisam de um esquema SQL estruturado.
* **SQLite no dispositivo** ou **armazenamento chave-valor** para dados locais
  que não precisam de um backend na nuvem por padrão.

## Compare as opções de banco de dados {:#compare-database-options}

Veja uma visão rápida de como cada opção armazena e sincroniza os dados:

| Opção | Modelo de dados | Localização dos dados | Atualizações em tempo real | Acesso offline |
|---|---|---|---|---|
| [Cloud Firestore][Cloud Firestore] | Documentos e coleções NoSQL | Nuvem, com cache local | Sim | Integrado (leitura e escrita) |
| [Firebase SQL Connect][Firebase SQL Connect] | Relacional (PostgreSQL) | Nuvem | Sim | Cache de consultas opcional |
| [SQLite no dispositivo][sqlite-recipe] | Relacional | Dispositivo por padrão | Streams locais (com `drift`) | Sempre local |
| [Armazenamento chave-valor][key-value-recipe] | Pares chave-valor | Somente no dispositivo | Não | Sempre local |

{:.table .table-striped}

## Escolha o Cloud Firestore para dados NoSQL {:#choose-cloud-firestore-for-nosql-data}

O [Cloud Firestore][Cloud Firestore] é o padrão recomendado quando o seu app precisa de
um banco de dados na nuvem escalável que mantém os dados sincronizados entre usuários e
dispositivos, como em apps de chat, ferramentas colaborativas, jogos multiplayer ao vivo
ou apps de serviço de campo e inspeção que precisam de cache offline.
Ele armazena os dados como documentos organizados em coleções, e o pacote
[`cloud_firestore`][`cloud_firestore`] permite que o seu app Flutter leia e grave
dados diretamente do código do cliente, protegidos pelas
[Regras de Segurança do Cloud Firestore][firestore-rules].

O Cloud Firestore é uma boa escolha quando o seu app precisa de:

* **Sincronização em tempo real:** escute um documento ou uma consulta e
  reconstrua a sua UI sempre que os dados mudarem,
  por exemplo, com o widget `StreamBuilder`.
* **Suporte offline:** leia e grave dados em cache enquanto o dispositivo está
  offline, e sincronize as alterações automaticamente quando a conexão voltar,
  sem precisar criar uma fila offline personalizada. A persistência offline vem
  habilitada por padrão no Android e nas plataformas Apple, e pode ser
  habilitada na web.
* **Dados flexíveis e em evolução:** armazene dados aninhados ou semiestruturados
  sem definir um esquema antecipadamente.
* **Escalabilidade automática:** lide com o crescimento do tráfego sem
  provisionar ou gerenciar servidores.

Para adicionar o Cloud Firestore ao seu projeto, execute:

```console
$ flutter pub add cloud_firestore
```

Depois, siga o [guia rápido do Cloud Firestore][firestore-quickstart]
para configurar o seu banco de dados.

:::note
O Cloud Firestore é o banco de dados NoSQL recomendado pelo Firebase para novos apps,
no lugar do [Firebase Realtime Database][realtime-db], a menos que o seu app
precise apenas de sincronização de baixa latência para pequenas atualizações
frequentes de estado, como indicadores de presença.
:::

## Escolha o Firebase SQL Connect para dados SQL {:#choose-firebase-sql-connect-for-sql-data}

Para dados estruturados e relacionais, como em uma loja virtual, um sistema de
agendamento de consultas, um controle de finanças pessoais ou um sistema de
estoque, o [Firebase SQL Connect][Firebase SQL Connect] (antes chamado de
Firebase Data Connect) é o padrão recomendado. O SQL Connect é apoiado por um
banco de dados PostgreSQL totalmente gerenciado no Cloud SQL. Você define o seu
esquema, as consultas e as mutações em GraphQL, implanta-os no servidor e os
chama no seu app Flutter usando um SDK Dart gerado e com tipagem segura,
com a tecnologia do pacote [`firebase_data_connect`][`firebase_data_connect`].

Os principais recursos incluem:

* **Dados relacionais:** modele entidades com relacionamentos,
  como usuários, pedidos e produtos, e faça consultas entre elas.
* **Esquema rígido:** imponha tipos de dados, restrições relacionais e chaves
  estrangeiras no banco de dados.
* **SDKs gerados com tipagem segura:** chame métodos Dart gerados para cada
  consulta e mutação de servidor predefinida, em vez de escrever consultas
  brutas ou duplicar modelos de dados manualmente. Como o SQL Connect gera
  SDKs de cliente diretamente do esquema do seu backend, o seu app Flutter
  permanece sincronizado com o banco de dados, sem divergência de esquema entre linguagens.
* **Atualizações em tempo real:** assine consultas para receber atualizações
  automáticas ou configuradas quando os dados mudarem.
* **Cache de consultas opcional:** armazene em cache as respostas das consultas no
  cliente para reduzir requisições de rede e ler resultados em cache quando estiver offline.
* **Busca vetorial:** crie recursos com IA, como busca semântica,
  sobre os seus dados relacionais.

Para adicionar o plugin SQL Connect ao seu projeto, execute:

```console
$ flutter pub add firebase_data_connect
```

Em seguida, siga o guia para
[usar os SDKs Flutter gerados][sql-connect-flutter] com o SQL Connect.

## Use SQLite ou armazenamento chave-valor localmente {:#use-sqlite-or-key-value-storage-locally}

Se os seus dados não precisam sair do dispositivo,
você pode armazená-los localmente, sem um backend na nuvem:

* **SQLite:** armazene e consulte grandes quantidades de dados relacionais estruturados
  no dispositivo. Use o [`sqflite`][`sqflite`] para consultas SQL diretas, ou o
  [`drift`][`drift`] para consultas Dart com tipagem segura, streams de dados reativos e
  migrações de esquema em dispositivos móveis, desktop e web. Para um exemplo passo a passo,
  veja [Persista dados com SQLite][sqlite-recipe], ou leia
  [Arquitetura de armazenamento persistente: SQL][sql-architecture] para aprender
  a estruturar uma camada de banco de dados local em um app maior.
* **Armazenamento chave-valor:** salve pequenas quantidades de dados simples,
  como preferências e configurações do usuário, com o pacote
  [`shared_preferences`][`shared_preferences`]. Comece com a receita
  [Armazene dados chave-valor em disco][key-value-recipe], ou veja
  [Arquitetura de armazenamento persistente: dados chave-valor][key-value-architecture].
  Para armazenar dados sensíveis, como tokens de autenticação ou registros criptografados,
  use o [`flutter_secure_storage`][`flutter_secure_storage`].

Por padrão, os pacotes de SQLite e chave-valor no dispositivo armazenam os dados somente
no dispositivo local. Assim, os dados não são sincronizados entre dispositivos nem
preservados se o usuário desinstalar o app sem um backup ou um serviço de sincronização.
Se os usuários esperarem acesso automático aos dados em vários dispositivos ou
após trocar de celular, use um banco de dados na nuvem, como o Cloud Firestore ou o
Firebase SQL Connect.

## Combine armazenamento na nuvem e local {:#combine-cloud-and-local-storage}

Você não precisa escolher apenas uma opção.
Por exemplo, o seu app pode usar o Cloud Firestore ou o Firebase SQL Connect para dados
compartilhados e sincronizados, junto com o `shared_preferences` para configurações
específicas do dispositivo, como a alternância de modo escuro.
Para aprender a combinar fontes de dados locais e remotas para que o seu app
continue funcionando sem conexão de rede, veja o
[Suporte offline primeiro][offline-first].

Tanto o Cloud Firestore quanto o Firebase SQL Connect também funcionam com outros
serviços do Firebase, incluindo o [Firebase Authentication][firebase-auth]
([`firebase_auth`][`firebase_auth`]), o
[Cloud Storage para Firebase][firebase-storage] ([`firebase_storage`][`firebase_storage`])
e o [Firebase AI Logic][firebase-ai] ([`firebase_ai`][`firebase_ai`]).
Por exemplo, o seu app pode capturar fotos de recibos ou inspeções, enviá-las para o
Cloud Storage, extrair campos estruturados com o Firebase AI Logic e sincronizar os
registros resultantes no Cloud Firestore ou no SQL Connect, tudo dentro de um único projeto.

Se o seu app precisar de lógica de backend personalizada, você também pode escrever
[Cloud Functions para Firebase ou servidores de backend em Dart][dart-server]
e compartilhar um único pacote Dart para os seus modelos de dados, serialização e
lógica de validação, tanto no cliente Flutter quanto no backend.

## Próximos passos {:#next-steps}

Para começar a criar um app com um banco de dados na nuvem, veja os recursos a seguir:

* [Adicione o Firebase ao seu app Flutter][firebase-setup]
* [Firebase para Flutter][firebase-page]
* [Comece com o Cloud Firestore][firestore-quickstart]
* [Firebase SQL Connect para Flutter][sql-connect-flutter]

[Cloud Firestore]: {{site.firebase}}/docs/firestore
[`cloud_firestore`]: {{site.pub-pkg}}/cloud_firestore
[dart-server]: {{site.dart-site}}/server#sharing-code-between-flutter-apps-and-dart-backends
[`drift`]: {{site.pub-pkg}}/drift
[firebase-ai]: {{site.firebase}}/docs/ai-logic/get-started
[`firebase_ai`]: {{site.pub-pkg}}/firebase_ai
[firebase-auth]: {{site.firebase}}/docs/auth/flutter/start
[`firebase_auth`]: {{site.pub-pkg}}/firebase_auth
[`firebase_data_connect`]: {{site.pub-pkg}}/firebase_data_connect
[firebase-page]: /data-and-backend/firebase
[firebase-setup]: {{site.firebase}}/docs/flutter/setup
[Firebase SQL Connect]: {{site.firebase}}/docs/sql-connect
[firebase-storage]: {{site.firebase}}/docs/storage/flutter/start
[`firebase_storage`]: {{site.pub-pkg}}/firebase_storage
[firestore-quickstart]: {{site.firebase}}/docs/firestore/quickstart
[firestore-rules]: {{site.firebase}}/docs/firestore/security/get-started
[`flutter_secure_storage`]: {{site.pub-pkg}}/flutter_secure_storage
[key-value-architecture]: /app-architecture/design-patterns/key-value-data
[key-value-recipe]: /cookbook/persistence/key-value
[offline-first]: /app-architecture/design-patterns/offline-first
[realtime-db]: {{site.firebase}}/docs/database/flutter/start
[`shared_preferences`]: {{site.pub-pkg}}/shared_preferences
[`sqflite`]: {{site.pub-pkg}}/sqflite
[sql-architecture]: /app-architecture/design-patterns/sql
[sql-connect-flutter]: {{site.firebase}}/docs/sql-connect/flutter-sdk
[sqlite-recipe]: /cookbook/persistence/sqlite
