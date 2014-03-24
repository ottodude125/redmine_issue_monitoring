Redmine::Plugin.register :redmine_issue_monitoring do
  name 'Redmine Issue Monitoring plugin'
  author 'Jonathan Katon'
  description 'A plugin for graphing issue status history.'
  version '0.0.1'
  url 'https://github.com/ottodude125/redmine_issue_monitoring'
  author_url 'https://github.com/ottodude125/redmine_issue_monitoring'

  menu :top_menu, :redmine_issue_monitoring, { :controller => 'history_by_tracker', :action => 'index' }, :caption => 'Issue Monitor'

end
