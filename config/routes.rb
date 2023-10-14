Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  get "/" => "home#index"
  get "/booking_date" => "booking#index"
  get "/booking_date/new" => "booking#new"
  get "/booking_date/show" => "booking#show"
  post "/booking_date/create" => "booking#create"
  get "/booking/host" => "booking#host"
  post "/booking/host/login" => "booking#host_login"
  get "/host" => "host#index"
  get "/host/show/:date_time" => "host#show", as: "user_show"
  get "/host/new" => "host#new", as:"host_new"
  post "/host/create" => "host#create"
  
end
