Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  namespace :api do
    namespace :v1 do
      resources :assets, except: %i[new edit]
      resources :accounts, except: %i[new edit]
      resources :lots, except: %i[new edit]
      resources :sales, except: %i[new edit]
      resources :sale_allocations, except: %i[new edit]
      resources :valuations, except: %i[new edit]
      resources :price_sources, except: %i[new edit]
      resources :adjustments, except: %i[new edit]
      resources :imports, except: %i[new edit]
      resources :audit_events, except: %i[new edit]
    end
  end

  root "dashboard#index"
end
