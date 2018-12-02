class DashboardController < ApplicationController
	before_action :check_login
  # authorize_resource

  def index
  	@officer = current_user.officer
  	if current_user.role == "officer"
  		@current_assignments = @officer.assignments.current.chronological.to_a.reverse
    	@past_assignments = @officer.assignments.past.chronological.to_a.reverse
    elsif current_user.role == "chief"
    	@unit = current_user.officer.unit
  		@unit_officers = @unit.officers.alphabetical.active.paginate(page: params[:page]).per_page(5)
    elsif current_user.role == "commish"
    	@recent_investigations = Investigation.is_open.where(['date_opened > ?', 30.days.ago]).chronological.to_a.reverse
    	@recent_assignments = Assignment.current.where(['start_date > ?', 30.days.ago]).chronological.to_a.reverse
    	@recent_suspects = Suspect.current.where(['added_on > ?', 30.days.ago]).chronological.to_a.reverse
    	@popular_crimes = s
    	@busy_officers
    end
  end

  
end