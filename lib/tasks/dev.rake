namespace :dev do
  desc "Configura ambiente desenvolvimento"
  task setup: :environment do
    puts "Resetando banco de dados"
    %x(rails db:drop db:create db:migrate)

    10.times do |i|
      Contact.create!(
        name: Faker::FunnyName.name,
        email: Faker::Internet::email,
        birthdate: Faker::Date.between(85.days.ago, 18.years.ago)
      )
    end
  end
end
