FactoryGirl.define do
  factory :user do
    sequence(:email)        { FFaker::Internet.email }
    sequence(:password)     { FFaker::Internet.password + rand(100...999).to_s }
  end
end
