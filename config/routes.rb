Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "healthcheck" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root "pages#index"

  # Dashboard
  get 'dashboard' => 'dashboard#index', as: 'dashboard'

  # The methods below are APIs that should only use JSON format
  defaults format: :json do
    # Provisioning
    post 'provision' => "provisioning#provision", as: 'provision'
    put 'update' => "provisioning#update", as: 'update'
    delete 'deactivate_endpoint' => "provisioning#deactivate_endpoint", as: 'deactivate_endpoint'
    delete 'deprovision' => "provisioning#deprovision", as: 'deprovision'

    # RPC
    post 'rpc' => "rpc#rpc", as: 'rpc'
  end

end
