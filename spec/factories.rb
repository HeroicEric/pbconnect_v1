require 'factory_girl'

FactoryGirl.define do

  factory :user do
    name "Foo Bar"
    password "foobar"
    sequence(:email){|n| "foo#{n}@bar.com"}
  end

  factory :update do
    sequence(:content){|n| "posted update#{n}." }
    association :user
  end

  factory :team do
    sequence(:name){|n| "Fake Team #{n}" }
  end

  factory :team_membership do
    role 'player'
    association :team
    association :user
  end

end
