
Rails.application.routes.draw do
  get '/pokemon', to: 'pokemon#nationaldex'
  get 'pokemon/:id', to: 'pokemon#show', as: 'pokemon_show'
  root 'pokemon#index'
end
