class DashboardController < ApplicationController
	before_action :check_login
  # authorize_resource

  def index
  	@officer = current_user.officer
  	@current_assignments = @officer.assignments.current.chronological.to_a.reverse
    @past_assignments = @officer.assignments.past.chronological.to_a.reverse
  end

  
end