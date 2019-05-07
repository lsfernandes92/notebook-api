namespace :dev do
  desc "Configura ambiente desenvolvimento"
  task setup: :environment do
    puts "=== Resetando banco de dados"
    %x(rails db:drop db:create db:migrate)

    puts "=== Cadastrando Tipos de contatos..."
    kinds = %w(Amigo Conhecido Chegado)

    kinds.each do |kind|
      Kind.create!(
        description: kind
      )
    end
    puts "=== Tipos cadastrado com sucesso!"

    puts "=== Cadastrando 10 contatos..."
    10.times do |i|
      Contact.create!(
        name: Faker::FunnyName.name,
        email: Faker::Internet::email,
        birthdate: Faker::Date.between(85.days.ago, 18.years.ago),
        kind: Kind.all.sample
      )
    end
    puts "=== Contatos cadastrados com sucesso!"

    puts "=== Cadastrando telefone para os contatos..."
    Contact.all.each do |contact|
      Random.rand(5).times do |i|
        phone = Phone.create!(number: Faker::PhoneNumber.cell_phone)
        contact.phones << phone
        contact.save!
      end
    end
    puts "=== Telefone cadastrados com sucesso"

    puts "=== Cadastrando endereço para os contatos..."
    Contact.all.each do |contact|
      address = Address.create!(
        street: Faker::Address.street_address,
        city: Faker::Address.city,
        contact: contact
      )
    end
    puts "=== Endereços cadastrados com sucesso"
  end
end
