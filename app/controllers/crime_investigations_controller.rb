class CrimeInvestigationsController < ApplicationController
  before_action :check_login
  authorize_resource

  def new
    @crime_investigation = CrimeInvestigation.new
    unless params[:investigation_id].nil?
      @investigation = Investigation.find(params[:investigation_id])
    end
    unless params[:crime_id].nil?
      @crime = Crime.find(params[:crime_id])
    end
  end
  
  def create
    @crime_investigation = CrimeInvestigation.new(crime_investigation_params)
    if @crime_investigation.save
      flash[:notice] = "Successfully added crime to investigation."
      redirect_to investigation_path(@crime_investigation.investigation)
    else
      @investigation = Investigation.find(params[:crime_investigation][:investigation_id])
      @crime = Crime.find(params[:crime_investigation][:crime_id])
      render action: 'new', locals: { investigation: @investigation, crime: @crime_id }
    end
  end

  def destroy
    @crime_investigation = CrimeInvestigation.find(params[:id])
    if @crime_investigation.destroy
      flash[:notice] = "Successfully removed crime from investigation."
      redirect_to investigation_path(@crime_investigation.investigation)
    end
  end

  private
  def crime_investigation_params
    params.require(:crime_investigation).permit(:crime_id, :investigation_id)
  end
end
