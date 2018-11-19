class SuspectsController < ApplicationController
  before_action :check_login


  def new
    @suspect = Suspect.new
    unless params[:criminal_id].nil?
      @criminal = Criminal.find(params[:criminal_id])
      @criminal_investigations = @criminal.suspects.current.map{|s| s.investigation }
    end
  end
  
  def create
    @suspect = Suspect.new(suspect_params)
    @suspect.added_on = Date.current
    if @suspect.save
      flash[:notice] = "Successfully added suspect."
      redirect_to criminal_path(@suspect.criminal)
    else
      @criminal = Criminal.find(params[:suspect][:criminal_id])
      render action: 'new', locals: { criminal: @criminal }
    end
  end

  def terminate
    @suspect = Suspect.find(params[:id])
    @suspect.dropped_on = Date.current
    @suspect.save
    redirect_to criminal_path(@suspect.criminal)
  end

  private
  def suspect_params
    params.require(:suspect).permit(:criminal_id, :investigation_id, :added_on, :dropped_on)
  end
end
