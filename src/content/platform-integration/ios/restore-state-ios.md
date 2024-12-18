---
ia-translate: true
title: "Restaurar o estado no iOS"
description: "Como restaurar o estado do seu aplicativo iOS após ele ser finalizado pelo SO."
---

Quando um usuário executa um aplicativo móvel e então seleciona outro aplicativo
para executar, o primeiro aplicativo é movido para o segundo plano ou _em
segundo plano_. O sistema operacional (tanto iOS quanto Android) frequentemente
finaliza o aplicativo em segundo plano para liberar memória ou melhorar o
desempenho do aplicativo em execução em primeiro plano.

Você pode usar as classes [`RestorationManager`][] (e relacionadas) para
lidar com a restauração de estado. Um aplicativo iOS requer [um pouco de
configuração extra][] no Xcode, mas as classes de restauração funcionam da
mesma forma tanto no iOS quanto no Android.

Para mais informações, confira [Restauração de estado no Android][] e o
exemplo de código [VeggieSeasons][].

[um pouco de configuração extra]: {{site.api}}/flutter/services/RestorationManager-class.html#state-restoration-on-ios
[`RestorationManager`]: {{site.api}}/flutter/services/RestorationManager-class.html
[Restauração de estado no Android]: /platform-integration/android/restore-state-android
[VeggieSeasons]: {{site.repo.samples}}/tree/main/veggieseasons
