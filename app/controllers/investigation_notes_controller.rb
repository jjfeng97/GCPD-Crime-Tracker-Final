class InvestigationNotesController < ApplicationController
  before_action :check_login


  def new
    @investigation_note = InvestigationNote.new
    unless params[:officer_id].nil?
      @officer = Officer.find(params[:officer_id])
      @officer_investigations = @officer.assignments.current.map{|a| a.investigation }
    end
  end
  
  def create
    @investigation_note = InvestigationNote.new(investigation_note_params)
    @investigation_note.date = Date.current
    if @investigation_note.save
      flash[:notice] = "Successfully added investigation note."
      redirect_to officer_path(@investigation_note.officer)
    else
      @officer = Officer.find(params[:investigation_note][:officer_id])
      render action: 'new', locals: { officer: @officer }
    end
  end

  def destroy
    @investigation_note.save
    redirect_to officer_path(@investigation_note.officer)
  end

  private
  def investigation_note_params
    params.require(:investigation_note).permit(:officer_id, :investigation_id, :date)
  end
end
