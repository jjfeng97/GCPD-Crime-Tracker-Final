class InvestigationNotesController < ApplicationController
  before_action :set_investigation_note, only: [:show, :edit, :update, :destroy]
  before_action :check_login
  authorize_resource

  def index
    @investigation = Investigation.find(params[:investigation_id])
    @notes = @investigation.investigation_notes.chronological.paginate(page: params[:page]).per_page(10)
  end

  def new
    @investigation_note = InvestigationNote.new
    unless params[:investigation_id].nil?
      @investigation = Investigation.find(params[:investigation_id])
    end
    unless params[:officer_id].nil?
      @officer = Officer.find(params[:officer_id])
    end
  end

  def edit
  end
  
  def create
    @investigation_note = InvestigationNote.new(investigation_note_params)
    @investigation_note.date = Date.current
    if @investigation_note.save
      flash[:notice] = "Successfully added investigation note to #{@investigation_note.investigation.title}."
      if @investigation_note.from == "dashboard"
        redirect_to dashboard_path
      else
        redirect_to investigation_path(@investigation_note.investigation)
      end
    else
      @investigation = Investigation.find(params[:investigation_note][:investigation_id])
      @officer = Officer.find(params[:investigation_note][:officer_id])
      render action: 'new', locals: { investigation: @investigation, officer: @officer }
    end
  end

  def update
    respond_to do |format|
      if @investigation_note.update_attributes(investigation_note_params)
        format.html { redirect_to investigation_path(@investigation_note.investigation), notice: "Successfully updated investigation note." }
        format.json { respond_with_bip(@investigation_note, investigation: @investigation) }
      else
        @investigation = Investigation.find(params[:investigation_note][:investigation_id])
        @officer = Officer.find(params[:investigation_note][:officer_id])
        format.html { render :action => "edit", locals: { investigation: @investigation, officer: @officer } }
        format.json { respond_with_bip(@investigation_note) }
      end
    end
  end

  def destroy
    if @investigation_note.destroy
      flash[:notice] = "Successfully removed investigation note."
      redirect_to investigation_path(@investigation_note.investigation)
    end
  end

  private
  def set_investigation_note
    @investigation_note = InvestigationNote.find(params[:id])
  end

  def investigation_note_params
    params.require(:investigation_note).permit(:from, :officer_id, :investigation_id, :content, :date)
  end
end
