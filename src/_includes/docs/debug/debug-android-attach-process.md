1. Clique no botão **Attach debugger to Android process**.
   (![Tiny green bug superimposed with a light grey arrow](/assets/images/docs/testing/debugging/native/android-studio/attach-process-button.png))

    :::tip
    Se este botão não aparecer na barra de menu **Projects**, verifique se
    você abriu o projeto de _aplicação_ Flutter mas _não um plugin Flutter_.
    :::

1. A caixa de diálogo **process** exibe uma entrada para cada dispositivo conectado.
   Selecione **show all processes** para exibir os processos disponíveis para cada
   dispositivo.

1. Escolha o processo ao qual você deseja anexar.
   Para este guia, selecione o processo `com.example.my_app`
   usando o **Emulator Pixel_5_API_33**.

{% comment %}

   @atsansone - 2023-07-24

   These screenshots were commented out for two reasons known for most docs:

   1. The docs should stand on their own.
   2. These screenshots would be painful to maintain.

   If reader feedback urges their return, these will be uncommented.

   ![Attach to Process dialog box open in Android Studio](/assets/images/docs/testing/debugging/native/android-studio/attach-process-dialog.png)
   <div class="figure-caption">

   Flutter app in Android device displaying two buttons.

   </div>
{% endcomment %}

1. Localize a aba para **Android Debugger** no painel **Debug**.

1. No painel **Project**, expanda
   **my_app_android** <span aria-label="and then">></span>
   **android** <span aria-label="and then">></span>
   **app** <span aria-label="and then">></span>
   **src** <span aria-label="and then">></span>
   **main** <span aria-label="and then">></span>
   **java** <span aria-label="and then">></span>
   **io.flutter plugins**.

1. Clique duas vezes em **GeneratedProjectRegistrant** para abrir o
   código Java no painel **Edit**.

{% comment %}
   !['The Android Project view highlighting the GeneratedPluginRegistrant.java file.'](/assets/images/docs/testing/debugging/native/android-studio/debug-open-java-code.png){:width="100%"}
   <div class="figure-caption">

   The Android Project view highlighting the `GeneratedPluginRegistrant.java` file.

   </div>
{% endcomment %}

No final deste procedimento, tanto os depuradores Dart quanto Android interagem
com o mesmo processo.
Use qualquer um, ou ambos, para definir breakpoints, examinar pilha, retomar execução
e similares. Em outras palavras, depure!

{% comment %}
![The Dart debug pane with two breakpoints set in `lib/main.dart`](/assets/images/docs/testing/debugging/native/dart-debugger.png){:width="100%"}
<div class="figure-caption">

The Dart debug pane with two breakpoints set in `lib/main.dart`.

</div>
{% endcomment %}

{% comment %}
!['The Android debug pane with one breakpoint set in GeneratedPluginRegistrant.java.'](/assets/images/docs/testing/debugging/native/android-studio/debugger-active.png)
<div class="figure-caption">

The Android debug pane with one breakpoint set in GeneratedPluginRegistrant.java.

</div>
{% endcomment %}
