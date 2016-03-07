Rails.application.routes.draw do

  scope "/:locale" , locale: /#{I18n.available_locales.join("|")}/ do
    root to: "sessions#new"
    resources :sessions, only: [:new, :create, :destroy]
    resources :users, only: [:new, :create, :edit, :update]
    resources :events, only: [:new, :create, :edit, :update, :index, :destroy] do
      get 'calendar', on: :collection
    end

  end

  get "/" => 'home#redirect_lang'
  get "/*path" => 'home#redirect_lang', constraints: {path: /(?!(#{I18n.available_locales.join("|")})\/).*/}, format: false

end