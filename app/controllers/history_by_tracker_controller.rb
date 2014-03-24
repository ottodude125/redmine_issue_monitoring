class HistoryByTrackerController < ApplicationController
  unloadable

  layout 'base'
  menu_item :redmine_issue_monitoring
  
  def index
    @weeks = []
    @open_bugs0004 = [] 
    @open_bugs0526 = []
    @open_bugs2752 = []
    @open_bugs53xx = []
    @open_supports0004 = [] 
    @open_supports0526 = []
    @open_supports2752 = []
    @open_supports53xx = []
    @open_features0004 = [] 
    @open_features0526 = []
    @open_features2752 = []
    @open_features53xx = []
    @open_issues0004 = [] 
    @open_issues0526 = []
    @open_issues2752 = []
    @open_issues53xx = []

    bug = Tracker.find_by_name("Bug").id
    feature = Tracker.find_by_name("Feature").id
    support = Tracker.find_by_name("Support").id
    st_date = (Time.now.to_date - 1.year) - (Time.now.to_date - 1.year).wday
    en_date = Time.now.to_date - Time.now.to_date.wday + 7.days
    while st_date < en_date
      start_date = st_date + 7.days

      srt0004 = start_date
      age0004 = start_date - (4*7+1).days
      bug0004     = get_issue_count(age0004, srt0004, start_date, bug)
      feature0004 = get_issue_count(age0004, srt0004, start_date, feature)
      support0004 = get_issue_count(age0004, srt0004, start_date, support)

      srt0526 = start_date - (4*7).days
      age0526 = start_date - (26*7+1).days
      bug0526     = get_issue_count(age0526, srt0526, start_date, bug)
      feature0526 = get_issue_count(age0526, srt0526, start_date, feature)
      support0526 = get_issue_count(age0526, srt0526, start_date, support)

      srt2752 = start_date - (26*7).days
      age2752 = start_date - (52*7+1).days
      bug2752     = get_issue_count(age2752, srt2752, start_date, bug)
      feature2752 = get_issue_count(age2752, srt2752, start_date, feature)
      support2752 = get_issue_count(age2752, srt2752, start_date, support)

      srt53xx = start_date - (52*7).days
      age53xx = start_date - (520*7+1).days
      bug53xx     = get_issue_count(age53xx, srt53xx, start_date, bug)
      feature53xx = get_issue_count(age53xx, srt53xx, start_date, feature)
      support53xx = get_issue_count(age53xx, srt53xx, start_date, support)

      week = start_date.strftime("%U").to_i%52 + 1
      @weeks << week
      @open_bugs0004 << bug0004
      @open_bugs0526 << bug0526
      @open_bugs2752 << bug2752
      @open_bugs53xx << bug53xx
      @open_supports0004 << support0004
      @open_supports0526 << support0526
      @open_supports2752 << support2752
      @open_supports53xx << support53xx
      @open_features0004 << feature0004
      @open_features0526 << feature0526
      @open_features2752 << feature2752
      @open_features53xx << feature53xx
      @open_issues0004 << (bug0004 + feature0004 + support0004)
      @open_issues0526 << (bug0526 + feature0526 + support0526)
      @open_issues2752 << (bug2752 + feature2752 + support2752)
      @open_issues53xx << (bug53xx + feature53xx + support53xx)
      st_date += 7.days
    end
  end

  private

  # range_st - lower bound
  # range_en - upper bound
  def get_issue_count(range_st, range_en, closed_on, tracker_id)
    iss_count = Issue.find_by_sql("SELECT id
                                    FROM issues
                                    WHERE
                                    ( tracker_id = #{tracker_id}
                                      AND created_on < '#{range_en}'
                                      AND created_on > '#{range_st}'
                                      AND closed_on > '#{closed_on}'
                                    )
                                    OR 
                                    ( tracker_id = #{tracker_id}
                                      AND created_on < '#{range_en}'
                                      AND created_on > '#{range_st}'
                                      AND closed_on IS NULL
                                    )").count
  end

end





