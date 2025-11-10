<!-- ia-translate: true -->

Se você está fazendo deploy para Android, edite seu arquivo `AndroidManifest.xml` para
adicionar a permissão de Internet.

```xml
<!-- Required to fetch data from the internet. -->
<uses-permission android:name="android.permission.INTERNET" />
```

Da mesma forma, se você está fazendo deploy para macOS, edite seus
arquivos `macos/Runner/DebugProfile.entitlements` e `macos/Runner/Release.entitlements`
para incluir o entitlement de cliente de rede.

```xml
<!-- Required to fetch data from the internet. -->
<key>com.apple.security.network.client</key>
<true/>
```
