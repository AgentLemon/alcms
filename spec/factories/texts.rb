FactoryGirl.define do
  factory :hello_text, class: Alcms::Text do
    name 'hello-text'
    content 'real hello world!'
    content_draft 'draft gello world!'
    association :block, factory: :hello_block
  end

  factory :past_text, class: Alcms::Text do
    name 'hello-text'
    content 'real past text'
    content_draft 'draft past text'
    association :block, factory: :past_block
  end

  factory :future_text, class: Alcms::Text do
    name 'hello-text'
    content 'real future text'
    content_draft 'draft future text'
    association :block, factory: :future_block
  end

  factory :present_text, class: Alcms::Text do
    name 'hello-text'
    content 'real present text'
    content_draft 'draft present text'
    association :block, factory: :present_block
  end
end
