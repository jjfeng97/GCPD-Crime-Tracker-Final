class OfficersController < ApplicationController
  before_action :set_officer, only: [:show, :edit, :update, :destroy]
  before_action :check_login
  authorize_resource

  def index
    @active_officers = Officer.active.alphabetical.paginate(page: params[:page]).per_page(10)
    @inactive_officers = Officer.inactive.alphabetical.paginate(page: params[:page]).per_page(10)
  end

  def show
    @current_assignments = @officer.assignments.current.chronological
    @past_assignments = @officer.assignments.past.chronological
  end

  def new
    @officer = Officer.new
  end

  def edit
    
  end

  def create
    @officer = Officer.new(officer_params)
    @user = User.new(user_params)
    @user.active = true
    # if @officer.save
    #   flash[:notice] = "Successfully created #{@officer.proper_name}."
    #   redirect_to officer_path(@officer) 
    # else
    #   render action: 'new'
    # end  

    if !@user.save
      @officer.valid?
      render action: 'new'
    else
      @officer.user_id = @user.id
      if @officer.save
        flash[:notice] = "Successfully created #{@officer.proper_name}."
        redirect_to officer_path(@officer) 
      else
        render action: 'new'
      end      
    end    
  end

  def update
    respond_to do |format|
      update_user_params
      if @officer.update_attributes(officer_params) and @user.save
        format.html { redirect_to @officer, notice: "Successfully updated all information for #{@officer.proper_name}." }
        format.json { respond_with_bip(@officer) }
      else
        format.html { render :action => "edit" } 
        format.json { respond_with_bip(@officer) } 
      end
    end
  end

  def destroy
    if @officer.destroy
      flash[:notice] = "Successfully deleted #{@officer.proper_name} from the GCPD system."
      redirect_to officers_path
    else
      @current_assignments = @officer.assignments.current.chronological
      @past_assignments = @officer.assignments.past.chronological
      flash[:error] = "#{@officer.proper_name} could not be deleted, so was instead made inactive."
      render action: 'show'
    end
  end

  def search
    redirect_back(fallback_location: officers_path) if params[:query].blank?
    @query = params[:query]
    @officers = Officer.search(@query)
    @total_hits = @officers.size
    if @total_hits == 0
      redirect_to officers_path
      flash[:error] = "No results found."
    elsif @total_hits == 1
      redirect_to officer_path(@officers.first)
    end
  end


  private
  # Use callbacks to share common setup or constraints between actions.
  def set_officer
    @officer = Officer.find(params[:id])
  end
  # Never trust parameters from the scary internet, only allow the white list through.
  def officer_params
    params.require(:officer).permit(:first_name, :last_name, :rank, :ssn, :active, :unit_id, :active, :username, :password, :password_confirmation, :role)
  end

  def user_params
    params.require(:officer).permit(:active, :username, :password, :password_confirmation, :role)
  end

  def update_user_params
    @user = @officer.user
    @user.role = officer_params[:role]
    @user.username = officer_params[:username] if !officer_params[:username].blank?
    @user.password = officer_params[:password] if @user.valid?
  end
end
