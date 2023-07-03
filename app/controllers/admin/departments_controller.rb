class Admin::DepartmentsController < Admin::AdminController
  def index
    @departments = Department.all
  end

  def new
    @department = Department.new
  end

  def create
    @department = Department.new(department_params)
    if @department.save
      redirect_to admin_departments_path, notice: 'Department created successfully.'
    else
      render :new
    end
  end

  def destroy
    @department = Department.find(params[:id])
    @department.destroy
    redirect_to admin_departments_path, notice: 'Department was successfully destroyed.'
  end

  def edit
    @department = Department.find(params[:id])
  end

  def update
    @department = Department.find(params[:id])
    if @department.update(department_params)
      redirect_to admin_departments_path, notice: 'Department was successfully updated.'
    else
      render :edit
    end
  end
  # Other actions: show, edit, update, destroy

  private

  def department_params
    params.require(:department).permit(:department_name)
  end
end
