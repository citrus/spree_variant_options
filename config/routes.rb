Rails.application.routes.draw do

  namespace :admin do
    resources :option_types do
      resources :option_values do
        collection do
          post :update_positions
        end
      end
    end
  end
  
end
