namespace :free_subscription do
  desc 'Create card numbers for existing applicants'

  task :create, [:order_id] => :environment do |t, args|
    @order_id = args[:order_id]

    puts "Free subscription is on creating for order id: #{@order_id}"

    begin
      @receipt = Receipt.find(@order_id)
    rescue
      puts 'Receipt is not found! Rake aborted!'
      exit
    end


    if !@receipt.is_paid
      CardNumber.find_or_create_by(:applicant_id => @receipt.applicant_id)
      @receipt.update(is_paid:true, price:0)
      @receipt.receipt_products.each do |rp|
        rp.product.decrement!(:stock)
      end
      begin
        KongreMailer.payment_accepted(@receipt).deliver!
      rescue
        puts 'An error occurred during mail sending!'
      end
    end

    puts 'Create rake is done!'
  end
end