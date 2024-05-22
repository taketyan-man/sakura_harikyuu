FactoryBot.define do
  factory :host do
    password              { 'password' }
    password_confirmation { 'password' }
  end
end