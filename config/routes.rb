Spree::Core::Engine.routes.append do

  namespace :admin do
    resources :option_values do
      collection do
        post :update_positions
      end
    end
  end
  
end
