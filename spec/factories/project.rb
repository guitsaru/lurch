FactoryGirl.define do
  factory :project do
    sequence(:repo) { |n| "br/breport_#{n}" }
    jenkins_id { repo.gsub('/', '-') }
  end
end
