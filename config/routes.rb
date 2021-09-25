Rails
  .application
  .routes
  .draw do
    namespace :api do
      mount_devise_token_auth_for "User",
                                  at: "auth",
                                  controllers: {
                                    registrations: "api/auth/registrations"
                                  }
      get "/get_users", to: "users#get_users"
      post "/get_user", to: "users#get_user"
      resources :posts, only: %i[show create update destroy]
      post "/get_posts", to: "posts#get_posts"
      resources :likes, only: %i[create]
      delete "/likes/:user_id/:post_id", to: "likes#destroy"
    end
  end
