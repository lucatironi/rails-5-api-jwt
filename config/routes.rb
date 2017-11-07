Rails.application.routes.draw do
  resource :authentications, only: %i[create]
  resources :customers, only: %i[index show create update destroy]
end
