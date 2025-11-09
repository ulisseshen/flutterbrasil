---
ia-translate: true
title: Configurar um arquivo de configuração de desenvolvimento web
shortTitle: Configuração de desenvolvimento web
description: >-
  Centralize configurações de desenvolvimento web incluindo um proxy de desenvolvimento
---

# Configurar um arquivo de configuração de desenvolvimento web
**Por Sydney Bao**

Flutter web inclui um servidor de desenvolvimento que por padrão
serve sua aplicação no domínio `localhost` usando HTTP
em uma porta atribuída aleatoriamente. Embora argumentos de linha de comando ofereçam
uma maneira rápida de modificar o comportamento do servidor,
este documento foca em uma abordagem mais estruturada:
definir o comportamento do seu servidor através de um arquivo `web_dev_config.yaml` centralizado.
Este arquivo de configuração permite que você
personalize configurações do servidor&emdash;host, porta, configurações HTTPS, e
regras de proxy&emdash;garantindo um ambiente de desenvolvimento consistente.

## Criar um arquivo de configuração

Adicione um arquivo `web_dev_config.yaml` ao diretório raiz do seu projeto Flutter.
Se você ainda não configurou um projeto Flutter,
visite [Construindo uma aplicação web com Flutter][Building a web application with Flutter] para começar.

[Building a web application with Flutter]: /platform-integration/web/building

## Adicionar configurações

### Configuração básica do servidor

Você pode definir o host, porta e configurações HTTPS para seu servidor de desenvolvimento.

```yaml title="web_dev_config.yaml"
server:
  host: "0.0.0.0" # Defines the binding address <string>
  port: 8080 # Specifies the port <int> for the development server
  https:
    cert-path: "/path/to/cert.pem" # Path <string> to your TLS certificate
    cert-key-path: "/path/to/key.pem" # Path <string> to TLS certificate key
```

### Headers personalizados

Você também pode injetar headers HTTP personalizados nas respostas do servidor de desenvolvimento.

```yaml title="web_dev_config.yaml"
server:
  headers:
    - name: "X-Custom-Header" # Name <string> of the HTTP header
      value: "MyValue" # Value <string> of the HTTP header
    - name: "Cache-Control"
      value: "no-cache, no-store, must-revalidate"
```

### Configuração de proxy

Requisições são correspondidas em ordem do arquivo `web_dev_config.yaml`.

#### Proxy de string básico

Use o campo `prefix` para correspondência simples de prefixo de caminho.

```yaml title="web_dev_config.yaml"
server:
  proxy:
    - target: "http://localhost:5000/" # Base URL <string> of your backend
      prefix: "/users/" # Path <string>
    - target: "http://localhost:3000/"
      prefix: "/data/"
      replace: "/report/" # Replacement <string> of path in redirected URL (optional)
    - target: "http://localhost:4000/"
      prefix: "/products/"
      replace: ""
```

**Explicação:**

*   Uma requisição para `/users/names` é
    encaminhada para `http://localhost:5000/users/names`.
*   Uma requisição para `/data/2023/` é
    encaminhada para `http://localhost:3000/report/2023`
    porque `replace: "/report/"` substitui o prefixo `/data/`.
*   Uma requisição para `/products/item/123` é
    encaminhada para `http://localhost:4000/item/123` porque `replace: ""`
    remove o prefixo `/products/` substituindo-o por uma string vazia.

#### Proxy regex avançado

Você também pode usar o campo `regex` para correspondência mais flexível e complexa.

```yaml title="web_dev_config.yaml"
server:
  proxy:
    - target: "http://localhost:5000/"
      regex: "/users/(\d+)/$" # Path <string> matches requests like /users/123/
    - target: "http://localhost:4000/"
      regex: "^/api/(v\d+)/(.*)" # Matches requests like /api/v1/users
      replace: "/$2?apiVersion=$1" # Allows capture groups (optional)
```

**Explicação:**

*   Uma requisição para `/users/123/` corresponde exatamente à primeira regra,
    então é encaminhada para `http://localhost:5000/users/123/`.
*   Uma requisição para `/api/v1/users/profile/` começa com o caminho da segunda regra
    então é encaminhada para `http://localhost:4000/users/profile/?apiVersion=v1`.

## Precedência de configuração

Lembre-se da ordem de precedência para configurações:

1. **Argumentos de linha de comando** (como `--web-hostname`, `--web-port`)
2. **Configurações do `web_dev_config.yaml`**
3. **Valores padrão integrados**
