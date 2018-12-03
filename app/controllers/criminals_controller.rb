class CriminalsController < ApplicationController
  before_action :set_criminal, only: [:show, :edit, :update, :destroy]
  before_action :check_login
  authorize_resource

  def index
    @felons = Criminal.prior_record.alphabetical.paginate(page: params[:page]).per_page(10)
    @nonfelons = Criminal.all.where(convicted_felon: false).alphabetical.paginate(page: params[:page]).per_page(10)
    @superpowers = Criminal.enhanced.alphabetical.paginate(page: params[:page]).per_page(10)
    @no_superpowers = Criminal.all.where(enhanced_powers: false).alphabetical.paginate(page: params[:page]).per_page(10)
    @criminals = Criminal.all.alphabetical.paginate(page: params[:page]).per_page(10)
  end

  def show
    @current_suspects = @criminal.suspects.current.chronological
    @previous_suspects = @criminal.suspects.alphabetical.to_a - @current_suspects
  end

  def new
    @criminal = Criminal.new
  end

  def edit
  end

  def create
    @criminal = Criminal.new(criminal_params)
    if @officer.save
      flash[:notice] = "Successfully created #{@criminal.proper_name}."
      redirect_to criminal_path(@criminal) 
    else
      render action: 'new'
    end      
  end

  def update
    respond_to do |format|
      if @criminal.update_attributes(criminal_params)
        format.html { redirect_to @criminal, notice: "Successfully updated information for #{@criminal.proper_name}." }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy
    if @criminal.destroy
      format.html { redirect_to criminals_path, notice: "Successfully deleted #{@criminal.proper_name}." }
    else
      @current_suspects = @criminal.suspects.current.chronological
      @previous_suspects = @criminal.suspects.alphabetical.to_a - @current_suspects
      render action: 'show'
    end
  end

  def search
    redirect_back(fallback_location: criminals_path) if params[:query].blank?
    @query = params[:query]
    @criminals = Criminal.search(@query)
    @total_hits = @criminals.size
    if @total_hits == 0
      redirect_to criminals_path
      flash[:error] = "No results found."
    elsif @total_hits == 1
      redirect_to criminal_path(@criminals.first)
    end 
  end


  private
  # Use callbacks to share common setup or constraints between actions.
  def set_criminal
    @criminal = Criminal.find(params[:id])
  end
  # Never trust parameters from the scary internet, only allow the white list through.
  def criminal_params
    params.require(:criminal).permit(:first_name, :last_name, :aka, :convicted_felon, :enhanced_powers, :notes)
  end


end
