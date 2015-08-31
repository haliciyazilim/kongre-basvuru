class Admin::WorkshopsController < AdminController
  def index
    @workshops = Workshop.all.order(:start_at)
  end

  def show
    @workshop = Workshop.find(params[:workshop_id])
    @applicants = @workshop.attendees
  end
end
