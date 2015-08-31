class Admin::WorkshopsController < AdminController
  def index
    @workshops = Workshop.all
  end

  def show
    @workshop = Workshop.find(params[:workshop_id])
    @applicants = @workshop.attendees
  end
end
