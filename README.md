# API (Application Programming Interface)

 Uma interface é uma intermediário para a comunicação entre dois elementos. Um exemplo básico da vida real seria uma pessoa que fala a língua portuguesa, outra pessoa que fala a língua inglesa e um tradutor. Nesse caso, o tratudor seria o intermediário e/ou interface.

 Com uma API é possível disponibilizar a aplicação para que ela tenha um funcionamento cross-platform.

 Também vale ressaltar que uma aplicação do tipo API substitui a camada de **view** de um modelo tradicional MVC. Ao invés da aplicação mostrar uma HTML com CSS e JS, o **.json** funcionará como view.

## Rails new --api

Apartir da versão 5 do rails é possível criar um projeto apenas com a flag **--api**:

`rails new notebook-api --api`

Para fazer com que um projeto existente transforme em API basta seguir dos passos do [Ruby Guides](http://edgeguides.rubyonrails.org/api_app.html#changing-an-existing-application).

## Cadastrando contatos com o Rake e Fake

A título de experimento gerei uma **scaffold** com os seguintes campos:

`rails g scaffold Contact name email birthdate:date`

Nesse momento se levantar o servidor e acessar **localhost:3000/contacts** nenhum contato será exibido.

Uma forma de automatizar a criação desses contatos é utilizando o **Rake** e a gem **Fake**.

No **Gemfile** adiciono:

```
group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  # A library for generating fake data such as names, addresses, and phone numbers.
  gem 'faker'
  ...
```

E após dou um `bundle install`.

### Nova task com Rake

`rails g task dev setup`

E editar o arquivo **lib/tasks/dev.rake**:

```
namespace :dev do
  desc "Configura ambiente de desenvolvimento"
  puts "Criando 10 contatos..."
  task setup: :environment do
    10.times do
      Contact.create!(
        name: Faker::Name.name,
        email: Faker::Internet.email,
        birthdate: Faker::Date.between(65.years.ago, 18.years.ago)
      )
    end
  end
  puts "Contatos criados com sucesso!"
end
```

Com isso será possível adicionar contatos rodando `rails dev:setup` ou `rake dev:setup`.

Links interessantes sobre o Rake:
  - [How to generate Rake task](https://railsguides.net/how-to-generate-rake-task/)
  - [Automatizando Tarefas com Ruby e Rake - AkitaOnRails](http://www.akitaonrails.com/2009/02/16/automatizando-tarefas-com-ruby-e-rake)

## Requests e Responses

Com uma URL é possível fazer uma request. E as **requests** podem ser enviadas de algumas maneiras e são elas:

  - URL (Required)

  `http://localhost:3000/contacts`
  - Parâmetros  

  `http://localhost:3000?param1=123&param2=567`
  - Verbo HTTP (Required)

  `GET, POST, DELETE, PATCH`
  - Header

  `Accept: application/json`

  - Dados Extras

  `JSON {name: 'John'}`

Já para as **responses** existem:

  - **Start-Line:** indica HTTP utilizado e Status da response
  - **Header-fields:** contém detalhes da request/response e como a transferência deve ser manipulada
  - **Empty-line:** separa cabeçalho da mensagem
  - **Message-body:** mensagem da response

### Outros comandos utéis usando cURL

`curl http://localhost:3000/contacts -v`: mostra detalhes de um request

`curl http://localhost:3000/contacts -i`: cabeçalho de uma response

`curl http://localhost:3000/contacts -i -v -X POST -H "Content-Type: application/json" -d "{"name": "lucas", "email": "lucas@email.com.br"}"`
  - `-v` dados request
  - `-i` dados response
  - `-X POST` o verbo utilizado
  - `-H "Content-Type: application/json"` como os dados serão enviados, também chamados de "Media Types/Mime Types"
  - `-d` os dados enviados

## REST? RESTful?

O protocolo HTTP em si só, possuia somente dois verbos, o GET e o POST. O REST é um conjunto de melhores práticas denominadas **constraints**.

Uma API que implementa todas as características/e ou constraints do REST, então ela é chamada de **RESTful**.

E as constraints são elas:

  - **Cliente/Servidor**: intuito de separar as diferentes responsabilidades de um sistema. Exemplo: MVC
  - **Stateless**: constitui que cada requisição não deve ter conexão com a requisição passada ou futura, ou seja, cada requisição terá de ter informações necessárias para ser processada com sucesso pelo servidor
  - **Cache**: as respostas devem ser passivas de Cache
  - **Interface Uniforme**: Seguir padrões de recursos, mensagens e hypermedia
  - **Sistema em camada**: Com intuito de permitir a escabilidade necessária para grandes sistemas distribuídos. Exemplo: Balanceador de carga
  - **Código sob demanda (opcional)**: A idéia é aumentar a flexibilidade dos clientes, como por exemplo um código javascript que só é baixado quando uma determinada página é carregada.

## Status Codes HTTP

Toda requisição para o servidor existe um Status do mesmo.

Basicamente existem 5 classes de status code, são elas:

  - **1xx** Informacional
  - **2xx** Success (entre cliente/servidor)
  - **3xx** Redirection (passo adicional)
  - **4xx** Client Error
  - **5xx** Server Error

Site útil: [HTTP's Statuses](https://httpstatuses.com/)

## CORS(Cross-origin requests)

Uma aplicação pode fazer request de imagem no seu próprio dominio e outro request de CEP - por exemplo - para outro servidor. E com isso esse terceiro servidor pode não estar disponível para essa consulta por motivos de segurança.

A gem [rack-cors](https://github.com/cyu/rack-cors) possibilita que qualquer dominio venha buscar dados em determinado servidor.

Site útil: [Resttesttes](https://resttesttest.com/)

## Sobre as responses

Classes do Rails que possibilita o trabalho com JSON

### Active Support JSON
### Active Model Serializers(AMS)

Dispõe uma maior flexibilidade para trabalhar com retornos JSON. Isso tudo pelos componentes **serializers** e **adapters**. Talvez o mais importante seja a possibilidade de conseguir tornar por padrão seguir uma especificação, a famigerada [{json:api}](https://jsonapi.org/). Com ela é possível seguir boas práticas caso haja alguma dúvida no momento da implementação da API.

Por padrão o AMS não vem com essa especificação e para isso basta criar um arquivo em `config/initializers/<AMS OU QUALQUER NOME>.rb` com o seguinte código:

`ActiveModelSerializers.config.adapter = :json_api`

Apartir disso o response já será diferente meio que da forma mágica do RoR.

Para fazer com que algum model responda com o AMS basta rodar o comando `rails g serializer <MODEL_NAME>`. Nesse momento esse serializer torna-se responsável por qualquer renderização json do projeto para determinado **<MODEL_NAME>** posteriormente criado pelo comando.

### Algumas boas práticas da especificação

* **Date and Time fields:** diz que todo retorno desse tipo deve vir com o padrão **1994-11-05T08:15:30-05:00 corresponds to November 5, 1994, 8:15:30 am, US Eastern Standard Time.** seguindo a ISO 8601.
* **Visualização de Campos Associados em Models:** Quando um model só guarda o _id_ de um outro model no qual faz associação(em rails quando determinado model tem um `belongs_to :<MODEL>`), o response dessa associação não vira descrito o que ela representa e sim somente o _id_, por exemplo um retorno já com a especificação implementada onde o tipo de `Contact` só traz o id do `Kind`:
```
{
    "data": [
        {
            "id": "1",
            "type": "contacts",
            "attributes": {
                "name": "Anna Sasin",
                "email": "karren@wiegand.net",
                "birthdate": "2003-05-18T00:00:00+00:00"
            },
            "relationships": {
                "kind": {
                    "data": {
                        "id": "2",
                        "type": "kinds"
                    },
                },
                ...
            }
        }
    ]
}
```
Para que seja sabido qual é o `Kind` com o `id` 2, a especificação diz que deve se incluir `include: :kind` no render do `ContactsController` no caso. Assim o final do JSON do response incluirá um nó parecido como:
```
{
    "data": {
        "id": "1",
        "type": "contacts",
        "attributes": {
            "name": "Anna Sasin",
            "email": "karren@wiegand.net",
            "birthdate": "2003-05-18T00:00:00+00:00"
        },
        "relationships": {
            "kind": {
                "data": {
                    "id": "2",
                    "type": "kinds"
                },
                ...
            }
        }
    },
    "included": [
        {
            "id": "2",
            "type": "kinds",
            "attributes": {
                "description": "Conhecido"
            }
        }
    ]
}
```
* **Informações extras**: Qualquer outro tipo de informação que não faz parte da realidade da sua aplicação vc pode adicionar nas chaves _meta_ adicionando nos Controllers `meta: { author: "Lucas Fernandes" }` ou para todos os responses colocando na classe `Serializer` o seguinte:
```
meta do
  { author: "Lucas Fernandes" }
end
```
* **Links([HATEOAS](https://en.wikipedia.org/wiki/HATEOAS))**: Faz parte de uma das constraints do RESTful, a _Interface Uniforme > Hypermedia_. Para isso basta inserir, por exemplo, no `Serializer` `link(:self) { contact_url(object.id) }`. Não só isso mas pode servir de alternativa no momento de trazer os campos associados visto no item "Visualização de Campos Associados em Models" que fala do uso do `include`. Para isso basta usar também no `Serializer` o seguinte:
```
belongs_to :kind, optional: true do
  link(:related) { kind_url(object.kind.id) }
end
```
Assim o final do JSON do response incluirá um nó parecido como:
```
{
    "data": {
        "id": "1",
        "type": "contacts",
        "attributes": {
            "name": "Anna Sasin",
            "email": "karren@wiegand.net",
            "birthdate": "2003-05-18T00:00:00+00:00"
        },
        "relationships": {
            "kind": {
                "data": {
                    "id": "2",
                    "type": "kinds"
                },
                "links": {
                    "related": "http://localhost:3000/kinds/2"
                }
            ...
```
* **Media Types ou MIME Types**: É a definição de "Uma string que define qual o formato do dado e como ele vai ser lido pela máquina. Isso permite um computador diferenciar entre JSON e XML, por exemplo". Eles fazem parte dos headers de uma requisição. Alguns exemplos são:
  * application/json
  * application/xml
  * multipart/form-data
  * text/html

A especificação diz que a responsabilidade do cliente e servidor é que seja requisitado e retornado a Media Type "application/vnd.api+json". Para tal basta adicionar `Mime::Type.register "application/vnd.api+json", :json` em **config/initializers/mime_types.rb**. E colocar algo parecido no nosso `ApplicationController`:
```
class ApplicationController < ActionController::API
  before_action :ensure_json_request

  def ensure_json_request
    return if request.headers["Accept"] =~ /vnd\.api\+json/
    render :nothing => true, :status => 406
  end
end
```
* **Tratamento de erros**: Quando ouver erros a indicação é que retorne um hash chamado _errors_ que pode conter um array de hashes com os seguintes valores [JSON:API#errors-processing](https://jsonapi.org/format/#errors-processing) para maior entendimento por parte do cliente.

Referências:
* ActiveModelSerializers: [GitHub Gem](https://github.com/rails-api/active_model_serializers)
* JSON:API Specification: [{json:api}](https://jsonapi.org/)

## Autenticações

Existem dois tipos básicos de autenticações, são elas:
### Simple Basic (Base64)
```
require 'base64'

Base64.encode64('user:pass')

# O strict faz encode sem o '\n' no final
Base64.strict_encode64('user:pass')
```
Para fazer uma requisição no curl `curl <URL> -u <USUARIO>:<SENHA>`

Referência de como usar no Rails: [ActionController::HttpAuthentication::Basic](https://api.rubyonrails.org/classes/ActionController/HttpAuthentication/Basic.html)
### Digest (MD5)
```
require 'digest/md5'

Digest::MD5.hexdigest('user:pass')
```
Para fazer uma requisição no curl `curl <URL> -u <USUARIO>:<SENHA> --digest`

_Obs: imporante ressaltar que esse método utiliza duas requests. A primeira virá com status code "não autorizado" e na segunda o curl fará automaticamente e responsável por passar alguns parametros a mais para fazer a requisição com sucesso. Caso essa requisição for feita no Postman esses dados extras terão que ser passado na segunda requisição vendo os headers de resposta da primeira requisição._

Referência de como usar no Rails: [ActionController::HttpAuthentication::Digest](https://api.rubyonrails.org/classes/ActionController/HttpAuthentication/Digest.html)

E também existem os tipos de autenticação Web:
### Autenticação baseada em Token

Quando um meio da interweb fornece um conjunto de caracteres que terá que ser usado no momento do request como forma de autenticação assim como os métodos acima.

O grande problema desse método é que ele é Stateful que contradiz uma das constraints do RESTful.

Para fazer uma requisição no curl `curl <URL> -H "Authorization: Token <TOKEN>"`

Referência de como usar no Rails: [ActionController::HttpAuthentication::Token](https://api.rubyonrails.org/classes/ActionController/HttpAuthentication/Token.html)

### JWT

[JSON Web Tokens](https://jwt.io/) é aberto e utiliza do o padrão da [RFC 7519](https://tools.ietf.org/html/rfc7519) que reinvidica a segurança entre ambas as partes.

JWT.IO permite que vc decodifique, verifique e gere um JWT.

Ele pretende resolver o problema de ter uma autenticação _Stateless_ que as outras autenticações não cobre. Sendo que o servidor não teria nenhuma infomação do cliente e ainda assim conseguiria autenticar.

Exemplo de Ruby com JWT e codificação HMAC:

```
hmac_secret = 'my$ecretK3y'

token = JWT.encode payload, hmac_secret, 'HS256'

# eyJhbGciOiJIUzI1NiJ9.eyJkYXRhIjoidGVzdCJ9.pNIWIL34Jo13LViZAJACzK6Yf0qnvT_BuwOxiMCPE-Y
puts token

decoded_token = JWT.decode token, hmac_secret, true, { algorithm: 'HS256' }

# Array
# [
#   {"data"=>"test"}, # payload
#   {"alg"=>"HS256"} # header
# ]
puts decoded_token
```

Referência: [Uma das Gems JWT](https://github.com/jwt/ruby-jwt)

### Devise Token Auth

Gem de autenticação recomendada pela própria gem do Devise. O interessante dessa alternativa é que ela é stateful, porém ainda assim é bastante utilizada.

O funcionamento dele é de gerar um `access-token` a cada requisição enviada para o servidor, sendo assim ao enviar uma requisição será gerado um novo token para a próxima request.

Para utilizar dessa gem basta adiciona-la no Gemfile e rodar `rails g devise_token_auth:install User auth` e adicionar o `before_action :authenticate_user!` no controller desejado para autenticação e rodar um `rails db:migrate`.

Referência: [Devise token Auth](https://github.com/lynndylanhurley/devise_token_auth)

## Versionamento

Por motivos óbvios de não querer que uma versão não atrapalhe a outra que está em produção existe o versionamento.

Algumas estratégias são:
* Query parameter: /users/100?v=1 (Gem Versionist)
* HTTP Header: Accept: application/vnd.example.com; version=1 (Gem Versionist)
* HTTP Custom Header: X-Version: 2.0 (Gem Versionist)
* Hostname ou subdomínio: v3.api.example.com
  * Basta adicionar o subdomínio no arquivo **/etc/hosts/** como por exemplo: `127.0.0.1    v1.meusite.local`
  * Nas rotas adicionar:
  ```
    constraints subdomain: 'v1' do
      scope module: 'v1' do
        resources :contacts do
          ...
        end
      end
    end
  ```
* Segmento de URL: /v1/users/100 (mais utilizado)
Obs: Para todos os métodos a cima é necessário alterar as rotas como a gem Versionist propõe e dividir os controller em **controllers/v1** e **controllers/v2**(utilizar a mesma estratégia para os serializers caso for de segmento de URL). Vale ressaltar também que o contra desses métodos acima é da duplicação de código no **routes.rb**

Referência: [Gem Versionist](https://github.com/bploetz/versionist)

## Paginação

### Paginação via HEADERS

Para tal no intuito de facilitar devemos usar o gem 'api-pagination' e/ou a 'kaminari/will_paginate' adicionando `gem 'api-pagination; gem 'kaminari'` no arquivo **Gemfile** e rodar um bundle.

No model podemos informar quantos registros queremos por pagina fazendo algo como:
```
class Contact < ApplicationRecord
  # Kaminari paginates
  paginates_per 5
  ...
  ...
  ...
end
```

Para o controller:
```
module V1
  class ContactsController < ApplicationController

    # GET /contacts
    def index
      @contacts = Contact.all.page(params[:page])

      # Metodo '.paginate' exclusivo da Gem 'api-pagination'
      paginate json: @contacts
    end
    ...
    ...
    ...
  end
end
```

O resultado disso será uma chama para _/contacts/_ trazendo apenas os cinco primeiro registros e a response virá com um header como:
```
Link: <http://localhost:3000/v1/contacts?page=1>; rel="first",
  <http://localhost:3000/v1/contacts?page=173>; rel="last",
  <http://localhost:3000/v1/contacts?page=6>; rel="next",
  <http://localhost:3000/v1/contacts?page=4>; rel="prev"
```
Indicando os URL para a navegação entre a paginação entre os registros.

Referêncas:
  * [Gem api-pagination](https://github.com/davidcelis/api-pagination)
  * [Gem kaminari](https://github.com/kaminari/kaminari)

### Paginação via JSON API

Do mesmo modo do que o método acima, para esse caso fazemos uso da gem 'kaminari'. Agora o kaminari só exigirá dois parametros para buscar e conseguir fazer o request já paginado. Os parametro são page[:number] e o page[:size].

Portanto o controller voltará para:
```
module V1
  class ContactsController < ApplicationController
    before_action :set_contact, only: [:show, :update, :destroy]

    # GET /contacts
    def index
      page_number = params[:page].try(:[], :number)
      per_page =  params[:page].try(:[], :size)

      @contacts = Contact.all.page(page_number).per(per_page)

      render json: @contacts
    end
    ...
    ...
    ...
  end
end
```

Com resposta disso o response agora voltará com um nó de links para a navegação entre a paginação. Algo no final do JSON parecido como:
```
"links": {
    "self": "http://localhost:3000/v1/contacts?page%5Bnumber%5D=1&page%5Bsize%5D=5",
    "first": "http://localhost:3000/v1/contacts?page%5Bnumber%5D=1&page%5Bsize%5D=5",
    "prev": null,
    "next": "http://localhost:3000/v1/contacts?page%5Bnumber%5D=2&page%5Bsize%5D=5",
    "last": "http://localhost:3000/v1/contacts?page%5Bnumber%5D=3&page%5Bsize%5D=5"
}
```
## Caching

Quando qualquer valor é difícil e computacionalmente custoso de obter deve ser cacheado. Como por exemplo reduzir ao máximo o response de, por exemplo, de um contato. Já será um ganho bem vindo se na próxima requisição só vir dados complementares para esse contato.

Para isso existe dois tipos basicamente, são eles:

* **Cache-Control**:
  Esse tipo é baseado em tempo, onde a próxima request fará uso das mesmas informações caso for igual a request anterior. Para esse tipo as mais utilizadas são:
    * Cache-control: max-age=3600, baseada em segundos e pode ser cacheado por intermediários e não só o browser
    * Cache-control: no-cache/no-store, o primeiro significa que pode ser cacheada mas não pode ser reusada sem antes consultar o servidor. O segundo diz que a resposta não pode ser cacheada em lugar nenhum.
    * Cache-control: private/public, max-age=86400, public para qualquer um que pode fazer cache e private para qualquer intermediário

  No Rails esse modo é usado pelo [expires_in](https://apidock.com/rails/ActionController/Base/expires_in) adicionando as especificações no controller.
* **ETag e/ou Last-modified**:
  Como o próprio nome diz funciona pelo tramite de uma Tag. Exemplo: Cliente realiza um GET, Server retorna uma ETag. Cliente realiza uma nova requisição(enviando o header ´If-None-Match: "VALOR_DA_TAG_DA_ULTIMA_RESPONSE"´), server compara a tag. Se for igual retorna status code **304 Not Modified** e caso contrário retorna **200 OK -- ETag: "<TAG>"**

  O mesmo funcionamento é dado para o _Last-modified_, porém em vez de um tag é usada a data.

  No rails a mágica acontece atraves do método [fresh_when](https://apidock.com/rails/ActionController/Base/fresh_when) para aplicação web e para API o [stale?](https://apidock.com/rails/ActionController/Base/stale%3F)

## Rack/Middleware

Rack é um pacote no Ruby que provê uma interface para o servidor web se comunicar com a aplicação.

Middleware é um termo que se refere a qualquer componente de software/biblioteca  que auxilia, mas não está diretamente envolvido na execução de algum tarefa.

Já um Rack Middleware é um componente situado entre a aplicação e o servidor e que porecssa requests e reponses.

Referência: https://rack.github.io/
