FactoryGirl.define do
  factory :hello_block, class: Alcms::Block do
    name 'hello-block'
  end

  factory :past_block, class: Alcms::Block do
    name 'hello-block'
    starts_at 10.days.ago
    expires_at 5.days.ago
    starts_at_draft 10.days.ago
    expires_at_draft 5.days.ago
  end

  factory :future_block, class: Alcms::Block do
    name 'hello-block'
    starts_at 5.days.from_now
    expires_at 10.days.from_now
    starts_at_draft 5.days.from_now
    expires_at_draft 10.days.from_now
  end

  factory :present_block, class: Alcms::Block do
    name 'hello-block'
    starts_at 5.days.ago
    expires_at 5.days.from_now
    starts_at_draft 5.days.ago
    expires_at_draft 5.days.from_now
  end
end
