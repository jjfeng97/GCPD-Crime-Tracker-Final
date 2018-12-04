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
      @units = Unit.active.paginate(page: params[:page]).per_page(5)
    	@recent_investigations = Investigation.is_open.where(['date_opened > ?', 30.days.ago]).chronological.to_a.reverse
    	@recent_assignments = Assignment.current.where(['start_date > ?', 30.days.ago]).chronological.to_a.reverse
    	@recent_suspects = Suspect.current.where(['added_on > ?', 30.days.ago]).chronological.to_a.reverse
    	@popular_crimes = CrimeInvestigation.select("crime_id, count(*) as total_count").order("total_count").group("crime_id").to_a.reverse[0,5]
    	@busy_officers = Assignment.select("officer_id, count(*) as total_count").order("total_count").group("officer_id").to_a.reverse[0,5]
    	@big_investigations = Assignment.select("investigation_id, count(*) as total_count").order("total_count").group("investigation_id").to_a.reverse[0,5]
    end
  end

  
end