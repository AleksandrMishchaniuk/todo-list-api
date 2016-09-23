FactoryGirl.define do
  factory :comment do
    sequence(:text) { FFaker::Lorem.paragraph }
    task
  end
end
