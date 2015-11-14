Alcms::Engine.routes.draw do
  resources :blocks, only: [:show] do
    post :save, on: :collection
    post :publish, on: :collection
  end
end
