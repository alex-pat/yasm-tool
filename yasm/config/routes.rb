Rails.application.routes.draw do
  devise_for :users, :controllers => { :omniauth_callbacks => "omniauth_callbacks",
                                       :registrations      => "registrations" }
  scope ":locale", locale: /#{I18n.available_locales.join("|")}/ do

    mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

    resources :users do
      resources :sites do
        resources :pages
        resources :comments
        post 'rate'
      end
      resources :pictures, only: [:index, :create, :update, :destroy]
    end

    resources :tags do
      collection do
        get 'current'
      end
    end

    root :to => 'sites#home'

    get '/search', to: "search#search", as: "search"
    post '/users/:user_id/pictures/update', to: 'pictures#update', as: 'update_picture'
  end

  match '*path', to: redirect("/#{I18n.default_locale}/%{path}"),
                 constraints: lambda { |req| !req.path.starts_with? "/#{I18n.default_locale}/" }, via: :all
  match '', to: redirect("/#{I18n.default_locale}"), via: :all
end
