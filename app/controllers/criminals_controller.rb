class CriminalsController < ApplicationController
  before_action :set_criminal, only: [:show, :edit, :update, :destroy]
  before_action :check_login


  def index
    @felons = Criminal.prior_record.alphabetical.paginate(page: params[:page]).per_page(10)
    @superpowers = Criminal.enhanced.alphabetical.paginate(page: params[:page]).per_page(10)
  end

  def show
    @current_suspects = @criminal.suspects.current.chronological
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
        format.html { redirect_to @criminal, notice: "Updated all information" }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy
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
