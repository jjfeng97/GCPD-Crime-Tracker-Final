class SuspectsController < ApplicationController
  before_action :check_login
  authorize_resource

  def new
    @suspect = Suspect.new
    unless params[:criminal_id].nil?
      @criminal = Criminal.find(params[:criminal_id])
      @criminal_investigations = @criminal.suspects.current.map{|s| s.investigation }
    end
    unless params[:investigation_id].nil?
      @investigation = Investigation.find(params[:investigation_id])
      @investigation_criminals = @investigation.suspects.current.map{|s| s.criminal }
    end
  end
  
  def create
    @suspect = Suspect.new(suspect_params)
    @suspect.added_on = Date.current
    if @suspect.save
      flash[:notice] = "Successfully added #{@suspect.criminal.proper_name} as a suspect of #{@suspect.investigation.title}."
      if @suspect.from == "criminal"
        redirect_to criminal_path(@suspect.criminal)
      else
        redirect_to investigation_path(@suspect.investigation)
      end
    else
      if @suspect.from == "criminal"
        @criminal = Criminal.find(params[:suspect][:criminal_id])
        render action: 'new', locals: { criminal: @criminal }
      else
        @investigation = Investigation.find(params[:suspect][:investigation_id])
        render action: 'new', locals: { investigation: @investigation }
      end
    end
  end

  def terminate
    @suspect = Suspect.find(params[:id])
    @suspect.dropped_on = Date.current
    @suspect.save
    flash[:notice] = "Successfully removed #{@suspect.criminal.proper_name} as a suspect from #{@suspect.investigation.title}."
    if @suspect.from == "criminal"
      redirect_to criminal_path(@suspect.criminal)
      # return
    else
      redirect_to investigation_path(@suspect.investigation)
      # return
    end
  end

  private
  def suspect_params
    params.require(:suspect).permit(:from, :criminal_id, :investigation_id, :added_on, :dropped_on)
  end
end
