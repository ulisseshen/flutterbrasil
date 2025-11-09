---
ia-translate: true
title: "Restaurar estado no iOS"
description: "Como restaurar o estado do seu app iOS depois que ele foi encerrado pelo sistema operacional."
---

Quando um usuário executa um app móvel e depois seleciona outro
app para executar, o primeiro app é movido para segundo plano,
ou _backgrounded_. O sistema operacional (tanto iOS quanto Android)
frequentemente encerra o app em segundo plano para liberar memória ou
melhorar o desempenho do app em execução em primeiro plano.

Você pode usar as classes [`RestorationManager`][`RestorationManager`] (e relacionadas)
para lidar com a restauração de estado.
Um app iOS requer [um pouco de configuração extra][a bit of extra setup] no Xcode,
mas as classes de restauração funcionam da mesma forma em
iOS e Android.

Para mais informações, consulte [Restauração de estado no Android][State restoration on Android]
e o exemplo de código [VeggieSeasons][VeggieSeasons].

[a bit of extra setup]: {{site.api}}/flutter/services/RestorationManager-class.html#state-restoration-on-ios
[`RestorationManager`]: {{site.api}}/flutter/services/RestorationManager-class.html
[State restoration on Android]: /platform-integration/android/restore-state-android
[VeggieSeasons]: https://github.com/samples/demos/tree/main/veggieseasons
