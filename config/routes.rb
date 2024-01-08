
Rails.application.routes.draw do
  get '/pokemon', to: 'pokemon#nationaldex'
  get 'pokemon/:id', to: 'pokemon#show', as: 'pokemon_show'
  get '/types', to: 'pokemon#types', as: 'pokemon_types'
  get '/types/:type_name', to: 'pokemon#pokemon_by_type', as: 'pokemon_by_type'
  root 'pokemon#index'
end
