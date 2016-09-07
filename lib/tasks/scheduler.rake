namespace :schedule do
  desc 'heroku scheduler tasks applicants'

  task :daily_info_mail => :environment do
    puts 'Started sending daily info mail'
    admins = ['emre@halici.com.tr']
    begin
      admins.each do |email|
        KongreMailer.daily_info_mail(email).deliver!
      end
    rescue
      puts "An error occurred during mail sending for daily info"
    end
    puts 'Ended sending daily info mail'
  end
end
