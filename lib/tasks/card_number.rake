
namespace :card_number do
  desc 'Create card numbers for existing applicants'

  task :create => :environment do
    cants = Receipt.where(:is_paid => true).where('created_at > ?', Time.now - 5.months).pluck(:applicant_id)
    applicants = Applicant.where(:id => cants).order('surname asc').pluck(:id)

    index = 100

    applicants.each do |t|
      CardNumber.create(:id => index, :applicant_id => t)
      index += 1
    end

  end
end
