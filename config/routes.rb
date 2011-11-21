N2::Application.routes.draw do
  resources :oauth_consumers do
    member do
      get :callback
    end
  end

  # TODO RAILS3
  #match 'locale' => '#index', :as => :filter
  #match 'iframe' => '#index', :as => :filter

  resource :oauth
  match '/oauth/create' => 'oauth#create', :as => :oauth_callback

  match '/auth/:provider/callback' => 'sessions#create', :as => :auth_provider_callback

  match '/robots.txt' => 'home#robots', :as => :robots

  match '/test_design.:format' => 'home#test_design', :as => :test_design

  match '/block.:format' => 'flags#block', :as => :toggle_blocked
  match '/feature.:format' => 'flags#feature', :as => :toggle_featured
  match '/like.:format' => 'votes#like', :as => :like_item
  match '/dislike.:format' => 'votes#dislike', :as => :dislike_item
  match '/logout.:format' => 'sessions#destroy', :as => :logout
  match '/login.:format' => 'sessions#new', :as => :login
  match '/register.:format' => 'users#create', :as => :register
  match '/signup.:format' => 'users#new', :as => :signup
  match '/account_menu.:format' => 'users#account_menu', :as => :account_menu
  match '/faq.:format' => 'home#faq', :as => :faq
  match '/about.:format' => 'home#about', :as => :about
  match '/terms.:format' => 'home#terms', :as => :terms
  match '/test_widgets.:format' => 'home#test_widgets', :as => :test_widgets
  match '/contact_us.:format' => 'home#contact_us', :as => :contact_us
  match '/app_tab.:format' => 'home#app_tab', :as => :app_tab
  match '/external_page.:format' => 'home#external_page', :as => :external_page
  match '/newswires/feed/:feed_id.:format' => 'newswires#feed_index', :as => :feed_newswires
  match '/articles/page/:page.:format' => 'articles#index', :as => :paged_articles
  match '/articles/user/:user_id.:format' => 'articles#user_index', :as => :user_articles
  match '/shared_item' => 'votes#shared_item', :as => :shared_item
  match '/articles/page/:page.:format' => 'articles#index', :as => :paged_articles_with_format
  match '/classifieds/page/:page.:format' => 'classifieds#index', :as => :paged_classifieds
  match '/classifieds/page/:page.:format' => 'classifieds#index', :as => :paged_classifieds_with_format
  match '/events/page/:page.:format' => 'events#index', :as => :paged_events
  match '/newswires/feed/:feed_id/page/:page.:format' => 'newswires#feed_index', :as => :paged_feed_newswires
  match '/forums/:id/page/:page.:format' => 'forums#show', :as => :paged_forums
  match '/forums/:id/page/:page.:format' => 'forums#show', :as => :paged_forums_with_format
  match '/galleries/page/:page.:format' => 'galleries#index', :as => :paged_galleries
  match '/galleries/page/:page.:format' => 'galleries#index', :as => :paged_galleries_with_format
  match '/ideas/page/:page.:format' => 'ideas#index', :as => :paged_ideas
  match '/idea_boards/:id/page/:page.:format' => 'idea_boards#show', :as => :paged_idea_boards
  match '/idea_boards/:id/page/:page.:format' => 'idea_boards#show', :as => :paged_idea_boards_with_format
  match '/events/:id/my_events/page/:page.:format' => 'events#my_events', :as => :paged_my_events
  match '/questions/:id/my_questions/page/:page.:format' => 'questions#my_questions', :as => :paged_my_questions
  match '/resources/:id/my_resources/page/:page.:format' => 'resources#my_resources', :as => :paged_my_resources
  match '/newswires/page/:page.:format' => 'newswires#index', :as => :paged_newswires
  match '/prediction_groups/page/:page.:format' => 'prediction_groups#index', :as => :paged_prediction_groups
  match '/questions/page/:page.:format' => 'questions#index', :as => :paged_questions
  match '/resources/page/:page.:format' => 'resources#index', :as => :paged_resources
  match '/stories/page/:page.:format' => 'stories#index', :as => :paged_stories
  match '/stories/page/:page.:format' => 'stories#index', :as => :paged_stories_with_format
  match '/articles/user/:user_id/page/:page.:format' => 'articles#user_index', :as => :paged_user_articles
  match '/users/:id/page/:page.:format' => 'users#show', :as => :paged_users
  match '/users/:id/page/:page.:format' => 'users#show', :as => :paged_users_with_format
  match '/articles/tag/:tag.:format' => 'articles#tags', :as => :tagged_articles
  match '/articles/tag/:tag/page/:page.:format' => 'articles#tags', :as => :tagged_articles_with_page
  match '/classifieds/tag/:tag.:format' => 'classifieds#tags', :as => :tagged_classifieds
  match '/classifieds/tag/:tag/page/:page.:format' => 'classifieds#tags', :as => :tagged_classifieds_with_page
  match '/stories/tag/:tag.:format' => 'stories#tags', :as => :tagged_contents
  match '/stories/tag/:tag/page/:page.:format' => 'stories#tags', :as => :tagged_contents_with_page
  match '/events/tag/:tag.:format' => 'events#tags', :as => :tagged_events
  match '/events/tag/:tag/page/:page.:format' => 'events#tags', :as => :tagged_events_with_page
  match '/forums/:forum_id/tag/:tag.:format' => 'topics#tags', :as => :tagged_forum
  match '/forums/:forum_id/tag/:tag/page/:page.:format' => 'topics#tags', :as => :tagged_forum_with_page
  match '/galleries/tag/:tag.:format' => 'galleries#tags', :as => :tagged_galleries
  match '/galleries/tag/:tag/page/:page.:format' => 'galleries#tags', :as => :tagged_galleries_with_page
  match '/ideas/tag/:tag.:format' => 'ideas#tags', :as => :tagged_ideas
  match '/ideas/tag/:tag/page/:page.:format' => 'ideas#tags', :as => :tagged_ideas_with_page
  match '/prediction_groups/tag/:tag.:format' => 'prediction_groups#tags', :as => :tagged_prediction_groups
  match '/prediction_groups/tag/:tag/page/:page.:format' => 'prediction_groups#tags', :as => :tagged_prediction_groups_with_page
  match '/prediction_questions/tag/:tag.:format' => 'prediction_questions#tags', :as => :tagged_prediction_questions
  match '/prediction_questions/tag/:tag/page/:page.:format' => 'prediction_questions#tags', :as => :tagged_prediction_questions_with_page
  match '/questions/tag/:tag.:format' => 'questions#tags', :as => :tagged_questions
  match '/questions/tag/:tag/page/:page.:format' => 'questions#tags', :as => :tagged_questions_with_page
  match '/resources/tag/:tag.:format' => 'resources#tags', :as => :tagged_resources
  match '/resources/tag/:tag/page/:page.:format' => 'resources#tags', :as => :tagged_resources_with_page
  match '/stories/tag/:tag.:format' => 'stories#tags', :as => :tagged_stories
  match '/stories/tag/:tag/page/:page.:format' => 'stories#tags', :as => :tagged_stories_with_page
  match '/ideas/tag/:tag/page/:page.:format' => 'ideas#tags', :as => :idea_tag_with_page
  match '/ideas/tag/:tag.:format' => 'ideas#tags', :as => :idea_tag
  match '/resources/tag/:tag/page/:page.:format' => 'resources#tags', :as => :resource_tag_with_page
  match '/resources/tag/:tag.:format' => 'resources#tags', :as => :resource_tag
  match '/events/tag/:tag/page/:page.:format' => 'events#tags', :as => :event_tag_with_page
  match '/events/tag/:tag.:format' => 'events#tags', :as => :event_tag
  match '/prediction_groups/tag/:tag/page/:page.:format' => 'prediction_groups#tags', :as => :prediction_group_tag_with_page
  match '/prediction_groups/tag/:tag.:format' => 'prediction_groups#tags', :as => :prediction_group_tag
  match '/prediction_questions/tag/:tag/page/:page.:format' => 'prediction_questions#tags', :as => :prediction_question_tag_with_page
  match '/prediction_questions/tag/:tag.:format' => 'prediction_questions#tags', :as => :prediction_question_tag
  match '/users/top/:top.:format' => 'users#index', :as => :top_users
  match '/classifieds/:id/set_status/:status.:format' => 'classifieds#set_status', :as => :set_status_classified
  match '/classifieds/category/:category.:format' => 'classifieds#categories', :as => :categorized_classifieds
  match '/classifieds/category/:category/page/:page.:format' => 'classifieds#categories', :as => :categorized_classifieds_with_page


  resources :amazon_products do
    collection do
      get :search
      post :search
    end
  end

  resource :session

  resources :answers do
    member do
      get :like
      post :like
    end
    resources :comments
    resources :answers
    resources :flags
  end

  resources :articles do
    collection do
      get :index
      post :index
      get :drafts
    end
  end

  resources :cards do
    collection do
      get :my_received
      get :my_sent
    end
    member do
      get :post_sent
      post :post_sent
      get :get_card_form
      post :get_card_form
    end
  end

  resources :classifieds do
    collection do
      get :borrowed_items
      get :my_items
    end
    resources :comments
    resources :fags
    resources :related_items
  end

  resources :comments do
    member do
      get :like
      post :like
      get :dislike
      post :dislike
    end
    resources :flags
  end

  # RAILS3 TODO
  resources :contents, :controller => :stories, :as => :stories

  resources :events do
    collection do
      get :index
      post :index
      get :import_facebook
      post :import_facebook
    end
    member do
      get :like
      post :like
      get :my_events
      post :my_events
    end

  end

  resources :forums do
    resources :topics
  end

  resources :galleries do
    member do
      get :add_gallery_item
      post :add_gallery_item
    end
    resources :comments, :flags, :related_items
  end

  resources :go, :only => :show

  resources :home do
    collection do
      get :about
      get :index
      post :index
      get :openx_ads
      get :contact_us
      post :contact_us
      get :helios_ads
      get :app_tab
      post :app_tab
      get :helios_alt2_ads
      get :preview_widgets
      get :faq
      get :helios_alt3_ads
      get :default_ads
      get :terms
      get :helios_alt4_ads
      get :google_ads
    end
    member do
      get :render_widget
      post :render_widget
    end

  end

  resources :idea_boards
  resources :ideas do
    collection do
      get :index
      post :index
    end
    member do
      get :like
      post :like
      get :my_ideas
      post :my_ideas
    end

  end

  resources :newswires do

    member do
      get :quick_post
      post :quick_post
    end

  end

  resources :prediction_groups do
    collection do
      get :index
      post :index
      get :play
      post :play
    end
    member do
      get :like
      post :like
    end

  end

  resources :prediction_questions do
    collection do
      get :index
      post :index
    end
    member do
      get :like
      post :like
    end

  end

  resources :predictions do
    collection do
      get :my_predictions
      post :my_predictions
      get :index
      post :index
      get :scores
      post :scores
    end


  end

  resources :questions do
    collection do
      get :index
      post :index
    end
  end
end
