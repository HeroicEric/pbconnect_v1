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

end
