class ActivityByWeekController < ApplicationController
  unloadable
  
  layout 'base'
  menu_item :redmine_issue_monitoring

  def index
    @created_issues = []
    @closed_issues = []
    @weeks = []
    start_date = (Time.now.to_date - 1.year) - (Time.now.to_date - 1.year).wday
    end_date = Time.now.to_date - Time.now.to_date.wday + 7.days
    while start_date < end_date
      eow = start_date + 7.days
      created = Issue.where(:created_on => (start_date..eow)).count
      closed  = Issue.where(:closed_on => (start_date..eow)).count
      week = start_date.strftime("%U").to_i%52 + 1
      @created_issues << created
      @closed_issues << closed
      @weeks << week
      start_date = eow
    end
  end

end