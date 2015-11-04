class Admin::WorkshopsController < AdminController
  def index
    @workshops = Workshop.all.order(:start_at)
  end

  def show
    @workshop = Workshop.find(params[:workshop_id])
    @applicants = @workshop.attendees
  end

  def get_applicants_as_word

    workshop=Workshop.find(params[:workshop_id])
    applicants = workshop.attendees
    template = Sablon.template(File.expand_path("public/workshop_template.docx"))
    context = {name: workshop.product.name, applicants:[]}

    applicants.each_with_index  do |applicant, index|
      applicant_name="#{applicant.name} #{applicant.surname}"
      currentApplicant={
          index:index+1,
          name:applicant_name,
          email:applicant.email,
          phone:applicant.phone,
          organization: applicant.organization,
          occupation: applicant.occupation
      }

      context[:applicants].push(currentApplicant)
    end



    data=template.render_to_string context

    send_data data, :filename => " Kongre #{workshop.product.name} Katılımcı Listesi.docx"
  end
end
