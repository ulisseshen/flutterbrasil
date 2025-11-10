Os exemplos nesta pasta costumavam estar em `src/_includes/code`. Apesar disso,
as fontes não estavam sendo incluídas em lugar nenhum. É provável que as fontes
apareçam em algumas páginas mesmo assim. O que precisa ser feito é o seguinte:

- Cada app/exemplo precisa ser totalmente revisado (e potencialmente simplificado).
- Se as fontes estão de fato sendo usadas nas páginas do site, então elas precisam ser
  integradas como trechos de código adequados. Consulte [Code excerpts][code-excerpts] para detalhes.
- Cada app/exemplo deve ser testado, pelo menos com um teste de fumaça.

[code-excerpts]: https://github.com/dart-lang/site-shared/blob/main/doc/code-excerpts.md
