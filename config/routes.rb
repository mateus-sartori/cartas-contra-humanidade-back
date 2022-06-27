Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  mount ActionCable.server => '/cable'

  get '/players', action: :wtf_meo, controller: :cartas_contra_humanidade_rules
  post '/players', action: :players, controller: :cartas_contra_humanidade_rules
end
