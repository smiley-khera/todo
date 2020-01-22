require 'faker'

FactoryBot.define do
  factory :todo_item do
    title { Faker::Lorem.word }
    description { Faker::Lorem.sentence }

    trait :pending do
      status { 'Pending'}
    end

    trait :start do
      status { 'Start'}
    end

    trait :finish do
      status { 'Finish'}
    end

    trait :with_tag do
      tags { |a| [a.association(:tag)] }
    end

    trait :deleted do
      deleted_at { Time.current }
    end
   end
end