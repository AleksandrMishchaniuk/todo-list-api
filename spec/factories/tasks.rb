FactoryGirl.define do
  factory :task do
    sequence(:text)       { FFaker::Lorem.phrase }
    sequence(:state)      { FFaker::Lorem.word }
    project
  end
end
