class UnitsController < ApplicationController
  before_action :set_unit, only: [:show, :edit, :update, :destroy]
  before_action :check_login
  authorize_resource
  
  def index
    @active_units = Unit.active.alphabetical.paginate(page: params[:page]).per_page(10)
    @inactive_units = Unit.inactive.alphabetical.paginate(page: params[:page]).per_page(10)
  end

  def show
    @officers = @unit.officers.active.alphabetical.paginate(page: params[:page]).per_page(10)
  end

  def new
    @unit = Unit.new
  end

  def edit
  end

  def create
    @unit = Unit.new(unit_params)
    if @unit.save
      redirect_to units_path, notice: "Successfully added #{@unit.name} to GCPD."
    else
      render action: 'new'
    end
  end

  def update
    respond_to do |format|
      if @unit.update_attributes(unit_params)
        format.html { redirect_to @unit, notice: "Successfully updated information for #{@unit.name}." }
        format.json { respond_with_bip(@unit) }
      else
        format.html { render :action => "edit" }
        format.json { respond_with_bip(@unit) }
      end
    end
  end

  def destroy
    if @unit.destroy
      flash[:notice] = "Successfully deleted #{@unit.name} from the GCPD system."
      redirect_to units_path
    else
      @officers = @unit.officers.active.alphabetical.paginate(page: params[:page]).per_page(10)
      render action: 'show'
    end
  end



  private
  def set_unit
    @unit = Unit.find(params[:id])
  end

  def unit_params
    params.require(:unit).permit(:name, :active)
  end
end
