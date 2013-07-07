FactoryGirl.define do
  factory :service do
    name 'service'
  end
  
  factory :team do
    sequence :name
    sequence :certname
  end

  factory :round do
    
  end

  factory :token do
    instance
    round
  end

  factory :availability do
    instance
    round
  end

  factory :redemption do
    team
    round
    token
  end

  factory :capture do
    redemption
    flag
  end

  factory :flag do
    team
  end
end