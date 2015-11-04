namespace :workshops do

  task :show_conflicts => :environment do

    # workshops = Workshop.joins(:product).where('workshops.product_id' => 'products.product_id').joins(:receipt).where(:receipts => {:applicant_id => 161})

    # workshop=Workshop.all
    # puts workshop
    #
    #
    # receipts=Receipt.where :is_paid => true
    #
    # puts receipts


    applicants=Applicant.all
    conflicts=[]
    applicants.each do |applicant|
      receipts=ReceiptProduct.joins(:receipt, :product).where("receipts.is_paid=:is_paid AND receipts.applicant_id=:app_id", {is_paid: true, app_id: applicant.id})

      workshops=[]

      receipts.each do |receipt|
        w=Workshop.find_by_product_id receipt.product.id
        if w
          workshops.push w
        end
      end


      workshops.each do |workshop_first|
        workshops.each do |workshop_second|

          next if workshop_first.id == workshop_second.id

          if (workshop_first.start_at - workshop_second.finish_at) * (workshop_second.start_at - workshop_first.finish_at) > 0
            c={}
            c['id']="#{applicant.id}-#{workshop_first.id}-#{workshop_second.id}"
            c['applicant']=applicant
            c['first']=workshop_first
            c['second']=workshop_second

            conflicts.push c
          end
        end
      end
    end


    puts "---------"
    puts "Conflicts Count: #{conflicts.count}"
    puts "---------"
    conflicts.each do |conflict|
      puts
      puts conflict
      puts
      puts "---------"
    end
  end

  def is_exist(conflicts, id)
    is_exist=false
    conflicts.each do |var|
      if var['id']== id
        is_exist= true
      end
    end

    is_exist
  end

end