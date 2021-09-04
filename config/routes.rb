Rails
    .application
    .routes
    .draw do
        namespace :api do
            mount_devise_token_auth_for "User",
                                        at: "auth",
                                        controllers: {
                                            registrations:
                                                "api/auth/registrations"
                                        }
            get "get_users/", to: "users#get_users"
        end
    end
