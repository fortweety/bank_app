FactoryBot.define do
  factory :account do
    user
    balance { BigDecimal('0') }
  end
end
