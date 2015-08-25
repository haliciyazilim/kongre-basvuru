
namespace :card_number do
  desc 'Create card numbers for existing applicants'

  task :create_all => :environment do
    Receipt.where(:is_paid => true).all.each do |receipt|
      applicant = receipt.applicant

      if !applicant.card_number
        CardNumber.create(:applicant => applicant)
      end
    end
  end
end
