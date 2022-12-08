Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get '/api/v1/items/:item_id/merchant', to: 'api/v1/merchants#show'
  
  namespace :api do 
    namespace :v1 do 
      namespace :merchants do 
        resources :find_all, only: [:index], to: "search#index"
      end
      resources :merchants, only: [:index, :show] do 
        resources :items, only: [:index]
      end
      resources :items, only: [:index, :show, :create, :update, :destroy]
    end
  end
end
