Rails.application.routes.draw do
  resource :authentications, only: %i[create]
end
