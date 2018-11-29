class DashboardController < ApplicationController
	before_action :check_login
  # authorize_resource

  def index
  	@officer = current_user.officer
  	if current_user.role == "officer"
  		@current_assignments = @officer.assignments.current.chronological.to_a.reverse
    	@past_assignments = @officer.assignments.past.chronological.to_a.reverse
    elsif current_user.role == "commish"
    	@recent_investigations = Investigation.is_open.chronological.to_a.reverse.slice(0, 5)
    	@recent_assignments = Assignment.current.chronological.to_a.reverse.slice(0, 5)
    	@recent_suspects = Suspect.current.chronological.to_a.reverse.slice(0, 5)
    end
  end

  
end