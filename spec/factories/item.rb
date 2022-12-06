FactoryBot.define do
  factory :item do
    merchant 
    name { Faker::Music::Hiphop.artist }
    description { Faker::Movies::HarryPotter.quote }
    unit_price { Faker::Number.decimal(l_digits: 2) }
  end
end

