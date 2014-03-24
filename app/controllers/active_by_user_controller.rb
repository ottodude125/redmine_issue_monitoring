class ActiveByUserController < ApplicationController
  unloadable

  layout 'base'
  menu_item :redmine_issue_monitoring


  def index
    #@res_custom_field = CustomField.find_by_name("Resolution")
    #@resolutions = @res_custom_field.possible_values
    #@statuses = IssueStatus.find_all_by_is_closed(false)
    #@issues = Issue.find(:all, :conditions => ["status_id IN (?)", @statuses])
    #@statuses = IssueStatus.find_by_sql("SELECT GROUP_CONCAT(id SEPARATOR ',') FROM `issue_statuses` WHERE is_closed = false")
    #@issues = Issue.find_by_sql("SELECT GROUP_CONCAT(id SEPARATOR ',') FROM `issues` WHERE status_id IN (1,3,5,7)")
    #@custom_values = CustomValue.find(:all, :conditions => ["custom_field_id = ? AND customized_id IN (?)", @res_custom_field.id, @issues])
    
    @issues_by_users = Issue.find_by_sql("SELECT id, IFNULL(assigned_to_id, 0) AS uid, COUNT(*) AS sum FROM issues
                                          WHERE status_id IN (1,3,5,7) GROUP BY assigned_to_id")
    @issues_by_user = @issues_by_users.map{|i| [get_name(i.uid), i.sum]}
    @categories = @issues_by_users.map{|i| [get_name(i.uid)]}
  end

  private

  def get_name(user_id)
    name = "Unassigned"
    if user_id > 0
      u = User.find(user_id)
      name = u.firstname + " " + u.lastname
    end
    name
  end
end