N2::Application.routes.draw do
  namespace :admin do
    match '/block.:format' => 'misc#block', :as => :block
    match '/flag_item.:format' => 'misc#flag', :as => :flag_item
    match '/feature.:format' => 'misc#feature', :as => :feature
    match '/featured_items/:id/load_items/page/:page' => 'featured_items#load_items', :as => :feature
    match '/translations.:format' => 'translations#translations', :as => :translations
    match '/asset_translations.:format' => 'translations#asset_translations', :as => :asset_translations

    resources :activity_scores
    resources :ad_layouts
    resources :ads
    resources :announcements
    resources :answers
    resources :cards
    resources :classifieds
    resources :comments
    resources :content_dashboard, :collection => { :news_topics => [:get, :post, :put] }
    resources :content_images
    resources :contents
    resources :dashboard_messages, :member => { :send_global => [:get, :post], :clear_global => [:get, :post] }, :collection => { :clear_global => [:get, :post] }
    resources :events, :collection => { :import_zvents => [:get, :post]}
    resources :featured_items, :member => { :load_template => [:get, :post], :load_new_template => [:get, :post], :load_items => [:get, :post] }, :collection => { :save => :post, :new_featured_widgets => :get, :save_featured_widgets => :post }
    resources :feeds, :member => { :fetch_new => :get }
    resources :flags
    resources :forums, :collection => { :reorder => [:get, :post] }
    resources :galleries
    resources :gos
    resources :idea_boards
    resources :ideas
    resources :images
    resources :locales, :collection => { :refresh => [:get] }, :has_many => :translations
    resources :newswires
    resources :prediction_groups, :member => { :approve => [:get, :post] }
    resources :prediction_guesses
    resources :prediction_questions, :member => { :approve => [:get, :post] }
    resources :prediction_results, :member => { :accept => [:get, :post] }
    resources :prediction_scores, :collection => { :refresh_all => [:get, :post ] }
    resources :questions
    resources :related_items
    resources :resource_sections
    resources :resources
    resources :settings
    resources :setting_groups
    resources :skip_images
    resources :sources
    resources :sponsor_zones
    resources :title_filters
    resources :topics
    resources :tweet_streams, :member => { :fetch_new_tweets => :get }
    resources :tweets
    resources :tweet_accounts
    resources :twitter_settings, :collection => { :update_keys => :post, :update_auth => :post, :reset_keys => :get }
    resources :user_profiles,      :active_scaffold => true
    resources :users,           :active_scaffold => true
    resources :view_objects
    resources :view_object_templates
    resources :votes,           :active_scaffold => true
    resources :widgets, :collection => { :save => :post, :new_widgets => :get, :newer_widgets => :get, :save_newer_widgets => :post }

    namespace :metadata do
      resources :activity_scores
      resources :ad_layouts
      resources :ads
      resources :custom_widgets
      resources :settings
      resources :skip_images
      resources :sponsor_zones
      resources :title_filters
    end
  end

  match 'admin' => "admin#index"
end
