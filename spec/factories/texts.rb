FactoryGirl.define do
  factory :hello_text, class: Alcms::Text do
    name 'hello-text'
    content 'hello world!'
    association :block, factory: :hello_block
  end

  factory :past_text, class: Alcms::Text do
    name 'hello-text'
    content 'past text'
    association :block, factory: :past_block
  end

  factory :future_text, class: Alcms::Text do
    name 'hello-text'
    content 'future text'
    association :block, factory: :future_block
  end

  factory :present_text, class: Alcms::Text do
    name 'hello-text'
    content 'present text'
    association :block, factory: :present_block
  end
end
