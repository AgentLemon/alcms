Alcms::Engine.routes.draw do
  resources :blocks, only: [:destroy] do
    post :save, on: :collection
    post :publish, on: :collection
    post :clone, on: :member
  end
end
