require 'faker'

FactoryBot.define do
  factory :tag do
    name { Faker::Commerce.department }
  end
end
