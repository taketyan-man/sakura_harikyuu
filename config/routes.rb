Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  get "/" => "home#index", as:"home"
  get "/booking_date" => "booking#index"
  get "/booking_date/new" => "booking#new"
  get "/booking_date/show/:id" => "booking#show", as:"booking_date_show"
  post "/booking_dates" => "booking#create"
  get "/booking/host" => "booking#host"
  post "/booking/host/login" => "booking#host_login"
  post "/booking/logout" => "host#host_logout"
  post "/booking/delete" => "booking#delete"
  get "/host" => "host#index"
  get "/host/show/:date_time" => "host#show", as: "user_show"
  get "/host/new" => "host#new", as:"host_new"
  post "/host/create" => "host#create"
  
end
