class InvestigationsController < ApplicationController
  before_action :set_investigation, only: [:show, :edit, :update, :close, :crimes]
  before_action :check_login
  authorize_resource

  def index
    @open_investigations = Investigation.is_open.chronological.paginate(page: params[:open_page]).per_page(10)
    @closed_investigations = Investigation.is_closed.chronological.paginate(page: params[:closed_page]).per_page(10)
    @closed_unsolved = Investigation.is_closed.unsolved.chronological.to_a.reverse.take(5)
    @with_batman = Investigation.with_batman.chronological.to_a.reverse.take(5)
  end

  def show
    @current_assignments = @investigation.assignments.current.by_officer.to_a
    @past_assignments = @investigation.assignments.by_officer.to_a - @current_assignments
    @current_suspects = @investigation.suspects.current.alphabetical.to_a
    @previous_suspects = @investigation.suspects.alphabetical.to_a - @current_suspects
    @case_crimes = @investigation.crime_investigations.to_a
    @officer = Officer.new
    @notes = @investigation.investigation_notes.chronological
  end

  def new
    @investigation = Investigation.new
  end

  def edit
  end

  def create 
    @investigation = Investigation.new(investigation_params)
    if @investigation.save
      redirect_to investigation_path(@investigation), notice: "Successfully added #{@investigation.title} to GCPD."
    else
      render action: 'new'
    end
  end

  def update
    @investigation = Investigation.find(params[:id])
    respond_to do |format|
      if @investigation.update_attributes(investigation_params)
        format.html { redirect_to @investigation, notice: "Successfully updated information for #{@investigation.title}." }
        format.json { respond_with_bip(@investigation) }
      else
        format.html { render :action => "edit" }
        format.json { respond_with_bip(@investigation) }
      end
    end
  end

  def close
    @investigation.date_closed = Date.current
    if @investigation.save
      redirect_to investigations_path, notice: "Successfully closed #{@investigation.title}."
    else
      @current_assignments = @investigation.assignments.current.by_officer.to_a
      @past_assignments = @investigation.assignments.by_officer.to_a - @current_assignments
      @current_suspects = @investigation.suspects.current.alphabetical.to_a
      @previous_suspects = @investigation.suspects.alphabetical.to_a - @current_suspects
      @case_crimes = @investigation.crime_investigations.to_a
      @officer = Officer.new
      @notes = @investigation.investigation_notes.chronological
      render action: 'show'
    end
  end

  def search
    redirect_back(fallback_location: investigations_path) if params[:query].blank?
    @query = params[:query]
    @investigations = Investigation.title_search(@query)
    @total_hits = @investigations.size
    if @total_hits == 0
      redirect_to investigations_path
      flash[:error] = "No results found."
    elsif @total_hits == 1
      redirect_to investigation_path(@investigations.first)
    end 
  end
  

  private
  def set_investigation
    @investigation = Investigation.find(params[:id])
  end

  def investigation_params
    params.require(:investigation).permit(:title, :description, :crime_location, :date_opened, :date_closed, :solved, :batman_involved)
  end
end
