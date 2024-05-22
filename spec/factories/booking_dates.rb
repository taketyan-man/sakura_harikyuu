FactoryBot.define do
  # sequence()
  # menus = [
  #       "ボディケア 60分",
  #       "ボディケア 90分",
  #       "ボディケア 120分",
  #       "鍼灸マッサージ 60分",
  #       "鍼灸マッサージ 90分",
  #       "鍼灸マッサージ 120分",
  #       "美容鍼 60分",
  #       "期間限定 60分"
  #     ]
  # 0 3 6 7 = 60 9:00  

  # factory :continuous_booking_date, class: BookingDate do
  #   transient do
  #     @menu = {[0, 1, 2, 3, 4, 5, 6, 9][rand(0..7)]}
  #     if menu % 3 == 0
  #       @e_time = "9:00"
  #     elsif menu % 3 == 1
  #       @e_time = "9:30"
  #     elsif menu % 3 == 2
  #       @e_time = "10:00"
  #     end
  #   end

  #   sequence(:name)       { |n| "User #{n}" } 
  #   sequence(:tell)      { |n| "0#{n * 10}" }
  #   sequence(:day)   { |n| "#{Date.today + n}"}
  #   menu { @menu }
  #   s_time { "8:00" }
  #   e_time { @e_time }
  #   tarait  
  #   password              { 'password' }
  #   password_confirmation { 'password' }
  #   activated             { true }
  # end
end
