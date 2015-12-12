Rails.application.routes.draw do
  mount Alcms::Engine => "/alcms"

  controller :home do
    get :index
    get :empty_block
  end
end
