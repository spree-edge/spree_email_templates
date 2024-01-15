Spree::Core::Engine.add_routes do
  # Add your extension routes here
  namespace :admin do
    resources :templates, only: [:index, :edit, :update]
  end
end
