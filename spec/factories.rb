require 'factory_girl'

FactoryGirl.define do

  factory :user do
    sequence(:name){|n| "Fake Name #{n}"}
    password "foobar"
    sequence(:email){|n| "foo#{n}@bar.com"}
  end

  factory :update do
    sequence(:content){|n| Faker::Lorem.sentence(10) }
    association :user
  end

  factory :team do
    sequence(:name){|n| "Fake Team #{n}" }
  end

  factory :team_membership do
    association :team
    association :user
    role 'member'
  end

end
