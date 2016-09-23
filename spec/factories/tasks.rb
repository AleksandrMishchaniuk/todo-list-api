FactoryGirl.define do
  factory :task do
    sequence(:text)       { FFaker::Lorem.phrase }
    project
  end
end
