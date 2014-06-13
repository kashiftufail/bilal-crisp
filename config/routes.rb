Crisp::Application.routes.draw do

  resource :corporate, :controller => :corporate, :only => :none do
    collection do 
      get '/', :action => :index
      get 'suit-and-shirt-plan', :action => :suit_and_shirt_plan, :as => :suit_and_shirt_plan
      get 'shirt-plan', :action => :shirt_plan, :as => :shirt_plan
      get :faq
    end
  end

  get 'gocardless/subscription_callback'


  ActiveAdmin.routes(self)

  devise_for :admin_users, ActiveAdmin::Devise.config

  resources :area_codes

  resources :price_lists

  resources :payment_details

  resources :companies, :format => :json, :only => :show

  resources :bookings do
   collection do
      get :confirmation
      get :discard
      get  :booking_message
    end
  end

  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  match '/logout' =>  'sessions#destroy'
  match '/login' =>  'sessions#new'
  match '/register' =>  'users#create'
  match '/signup(/:category/:name)' =>  'users#new', :as => :signup
  match '/edit/:id' =>  'users#edit', :as => :edit
  match '/about' =>  'main#about'
  match '/price_list' =>  'main#price_list'
  # match '/corporate' =>  'main#corporate'
  match '/blog' =>   redirect {|params, request| "http://blog.#{request.domain(2)}" }
  match '/faq' =>  'main#faq'
  match '/contact' =>  'main#contact'
  match '/media' =>  'main#media'
  match '/privacy_policy' =>  'main#privacy_policy'
  match '/subscribe_to_newsletter' =>  'main#subscribe_to_newsletter'
  match '/account' =>  'accounts#index'
  match '/admin' =>  'admin#index'
  match '/admin_login' =>  'admin#login'
  resources :users do 
    member do
      post :update
      get :change_password
      post :update_password
    end
  end


  resource :session

  root :to => "main#index"

  match  '/p/:code' => 'main#reset_password'
  match '/:ref_id' => 'users#new', :as => :invitation

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => "welcome#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
   match ':controller(/:action(/:id(.:format)))'
end
