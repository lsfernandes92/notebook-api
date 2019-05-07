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
  end
end
