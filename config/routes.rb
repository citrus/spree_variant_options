Spree::Core::Engine.routes.draw do

  namespace :admin do
    resources :option_values, only: [] do
      collection do
        post :update_positions
      end
    end
  end

end
