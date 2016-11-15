namespace :mail do
  desc 'Create card numbers for existing applicants'

  task :send_info_mail => :environment do

    CardNumber.where('id > 881').each do |card_number|
      begin
        KongreMailer.attendance_info_mail(card_number.applicant).deliver!
      rescue
        puts "An error occurred during mail sending for CardNumber: #{card_number.id}"
      end
    end
  end
end