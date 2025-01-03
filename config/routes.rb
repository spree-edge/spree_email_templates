Spree::Core::Engine.add_routes do
  # Add your extension routes here
  namespace :admin do
    resources :templates, only: [:index, :edit, :update] do
      post 'test_email', on: :member
      post 'clone', on: :member
    end

    resources :stores do
      resource :email_templates, only: [:edit, :update]
    end
  end
end
