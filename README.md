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
  - `-H "Content-Type: application/json"` como os dados serão enviados
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


## AMS(Active Model Serializers JSON)

Classes do Rails que possibilita o trabalho com JSON

### Active Support JSON
### Active Model Serializers JSON

Dispõe uma maior flexibilidade para trabalhar com retornos JSON. Isso tudo pelos componentes **serializers** e **adapters**.

Para fazer com que algum model responda com o AMS basta rodar o comando `rails g serializer <MODEL_NAME>`.

JSON:API Specification: [{json:api}](https://jsonapi.org/)
