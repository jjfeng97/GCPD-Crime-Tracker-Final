class InvestigationNotesController < ApplicationController
  before_action :set_investigation_note, only: [:show, :edit, :update, :destroy]
  before_action :check_login


  def new
    @investigation_note = InvestigationNote.new
    unless params[:officer_id].nil?
      @officer = Officer.find(params[:officer_id])
      @officer_investigations = @officer.assignments.current.map{|a| a.investigation }
    end
  end

  def edit
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

  def update
    respond_to do |format|
      if @investigation_note.update_attributes(criminal_params)
        flash[:notice] = "Successfully updated investigation note."
        redirect_to officer_path(@investigation_note.officer)
      else
        @officer = Officer.find(params[:investigation_note][:officer_id])
        render action: 'edit', locals: { officer: @officer }
      end
    end
  end

  def destroy
    if @investigation_note.destroy
      redirect_to officer_path(@investigation_note.officer)
    end
  end

  private
  def set_investigation_note
    @investigation_note = InvestigationNote.find(params[investigation_note_params])
  end

  def investigation_note_params
    params.require(:investigation_note).permit(:officer_id, :investigation_id, :date)
  end
end
