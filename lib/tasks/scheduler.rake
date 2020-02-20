namespace :schedule do
  desc 'heroku scheduler tasks applicants'

  task :daily_info_mail => :environment do
    puts 'Started sending daily info mail'
    #admins = ['emre@halici.com.tr', 'ezgi@tzv.org.tr', 'emrehan@halici.com.tr', 'eren@halici.com.tr', 'utku@halici.com.tr']
    admins = "emre@halici.com.tr, ezgi@tzv.org.tr, emrehan@halici.com.tr, eren@halici.com.tr, kader@tzv.org.tr, utku@halici.com.tr"
    begin
      KongreMailer.daily_info_mail(admins).deliver!
      # admins.each do |email|
      #   KongreMailer.daily_info_mail(email).deliver!
      # end
    rescue
      puts "An error occurred during mail sending for daily info"
    end
    puts 'Ended sending daily info mail'
  end
end
