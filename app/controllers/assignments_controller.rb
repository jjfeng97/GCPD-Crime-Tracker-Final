class AssignmentsController < ApplicationController
  before_action :check_login
  authorize_resource

  def new
    @assignment = Assignment.new
    unless params[:officer_id].nil?
      @officer = Officer.find(params[:officer_id])
      @officer_investigations = @officer.assignments.current.map{|a| a.investigation }
    end
    unless params[:investigation_id].nil?
      @investigation = Investigation.find(params[:investigation_id])
      @investigation_officers = @investigation.assignments.current.map{|a| a.officer }
    end
  end
  
  def create
    @assignment = Assignment.new(assignment_params)
    @assignment.start_date = Date.current
    if @assignment.save
      flash[:notice] = "Successfully assigned #{@assignment.officer.proper_name} to #{@assignment.investigation.title}."
      from = params[:from]
      if @assignment.from == "dashboard"
        redirect_to dashboard_path
      elsif @assignment.from == "officer"
        redirect_to officer_path(@assignment.officer)
      else
        redirect_to investigation_path(@assignment.investigation)
      end

    else
      if @assignment.from == "officer"
        @officer = Officer.find(params[:assignment][:officer_id])
        render action: 'new', locals: { officer: @officer }
      else
        @investigation = Investigation.find(params[:assignment][:investigation_id])
        render action: 'new', locals: { investigation: @investigation}
      end
    end
  end

  def terminate
    @assignment = Assignment.find(params[:id])
    @assignment.end_date = Date.current
    @assignment.save
    from = params[:from]
    flash[:notice] = "Successfully removed #{@assignment.officer.proper_name} from #{@assignment.investigation.title}."
    if from == "officer"
      redirect_to officer_path(@assignment.officer)
    elsif from == "dashboard"
      redirect_to dashboard_path
    else
      redirect_to investigation_path(@assignment.investigation)
    end

  end

  private
  def assignment_params
    params.require(:assignment).permit(:from, :investigation_id, :officer_id, :start_date, :end_date)
  end
end
