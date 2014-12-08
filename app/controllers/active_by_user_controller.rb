class ActiveByUserController < ApplicationController
  unloadable

  layout 'base'
  menu_item :redmine_issue_monitoring


  def index
    @res_custom_field = CustomField.find_by_name("Resolution")
    @resolutions = @res_custom_field.possible_values
    @issues = Issue.find_by_sql("SELECT IFNULL(issues.assigned_to_id,1) as assign_id, IFNULL(custom_values.value, 'None') AS resolution, 
                                    issue_statuses.name AS status_name, issue_statuses.id AS status_id, 
                                    COUNT(*) AS count
                                  FROM issues, issue_statuses, custom_values
                                  WHERE issue_statuses.name != 'Closed'
                                  AND issue_statuses.name != 'Rejected'
                                  AND issues.status_id = issue_statuses.id
                                  AND custom_values.customized_type = 'Issue'
                                  AND custom_values.custom_field_id = #{@res_custom_field.id}
                                  AND custom_values.customized_id = issues.id
                                  GROUP BY assign_id, status_name, resolution
                                  ORDER BY assign_id, status_id")
    # Build array of rows to display
    @rows = []
    cur_user = @issues.first.assign_id
    cur_stat = @issues.first.status_name
    count = 0
    temp_rows = []
    temp_row = Array.new(@resolutions.count + 3){|c| 0}
    sum_row = Array.new(@resolutions.count + 3){|c| 0}
    sum_row[0] = ""
    sum_row[1] = ""
    @issues.each do |i|
      # if issue is different user than last then
      # create row with last users name 
      # then push all temp_rows (each status row) into the @rows array
      # this user now complete so clear count, and temp_rows
      # and reset cur_user to the new user
      if (i.assign_id != cur_user)
        row = Array.new(@resolutions.count + 3)
        u = User.find(cur_user)
	name = "Unassigned"
	if cur_user != 1
	  name = u.firstname + " " + u.lastname
	end
        row[0] = name
        row[1] = temp_rows.length + 2
        @rows << row
        temp_row[0] = ""
        temp_row[1] = cur_stat
        temp_row[temp_row.length-1] += count
        sum_row[temp_row.length-1] += count
        temp_rows << temp_row
        temp_rows.each do |t|
          @rows << t
        end
        @rows << sum_row
        temp_row = Array.new(@resolutions.count + 3){|c| 0}
        sum_row = Array.new(@resolutions.count + 3){|c| 0}
        sum_row[0] = ""
        sum_row[1] = ""
        temp_rows = []
        cur_stat = i.status_name
        count = 0
        cur_user = i.assign_id
      # if on same user but different status then push current status row into temp rows array
      # and reinitialize the temp_row array
      elsif (i.status_name != cur_stat)
        logger.debug temp_row
        temp_row[0] = ""
        temp_row[1] = cur_stat
        temp_row[temp_row.length-1] += count
        sum_row[temp_row.length-1] += count
        temp_rows << temp_row
        temp_row = Array.new(@resolutions.count + 3){|c| 0}
        cur_stat = i.status_name
        count = 0
      end
      # increment count by issue count and push count in correct resolution column
      count += i.count
      res = (i.resolution == "") ? "None" : i.resolution
      temp_row[@resolutions.index(res) + 2] += i.count
      sum_row[@resolutions.index(res) + 2] += i.count
    end
    row = Array.new(@resolutions.count + 3)
    u = User.find(cur_user)
    row[0] = u.firstname + " " + u.lastname
    row[1] = temp_rows.length + 2
    @rows << row
    temp_row[0] = ""
    temp_row[1] = cur_stat
    temp_row[temp_row.length-1] += count
    sum_row[temp_row.length-1] += count
    temp_rows << temp_row
    temp_rows.each do |t|
      @rows << t
    end
    @rows << sum_row



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
