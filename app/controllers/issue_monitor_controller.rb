class IssueMonitorController < ApplicationController
  unloadable

  layout 'base'
  menu_item :redmine_issue_monitoring
  
  def index
 	active_statuses = IssueStatus.where(:is_closed => false)
 	@total_active_issues = Issue.find(:all, :conditions => ["status_id IN (?)", active_statuses]).count
 	@active_iss_stat_summary = IssueStatus.find_by_sql("SELECT iss.id, iss.name AS name, IFNULL(s.stat_total, 0) AS stat_total
														FROM issue_statuses AS iss
														LEFT JOIN (
														  SELECT status_id, COUNT(status_id) as stat_total
														  FROM issues
														  GROUP BY status_id
														) AS s
														ON s.status_id = iss.id
														WHERE iss.is_closed = 0
														GROUP BY iss.id")

 	@total_issues = Issue.count
 	@all_iss_stat_summary = IssueStatus.find_by_sql("SELECT iss.id, iss.name AS name, IFNULL(s.stat_total, 0) AS stat_total
													FROM issue_statuses AS iss
													LEFT JOIN (
													  SELECT status_id, COUNT(status_id) as stat_total
													  FROM issues
													  GROUP BY status_id
													) AS s
													ON s.status_id = iss.id
													GROUP BY iss.id")

  end
end


