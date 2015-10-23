namespace :mail do
  desc 'Create card numbers for existing applicants'

  task :send_info_mail => :environment do
    CardNumber.all.each do |card_number|
      KongreMailer.attendance_info_mail(card_number.applicant).deliver
    end
  end
end