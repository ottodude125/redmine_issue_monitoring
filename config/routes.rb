# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html


get 'issue_monitor', :to => 'issue_monitor#index'
get 'active_by_user', :to => 'active_by_user#index'
get 'activity_by_week', :to => 'activity_by_week#index'
get 'history_by_tracker', :to => 'history_by_tracker#index'

