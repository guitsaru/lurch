FactoryGirl.define do
  factory :build do
    sequence(:sha) { |n| "abcdefg#{1}" }
    sequence(:repo) { |n| "br/breport_#{n}" }
    sequence(:jenkins_id)

    association(:project)
  end
end
