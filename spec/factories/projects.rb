FactoryGirl.define do
  factory :project do
    sequence(:title)    { FFaker::Movie.title }
    user
  end
end
