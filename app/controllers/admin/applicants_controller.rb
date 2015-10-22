
class Admin::ApplicantsController < AdminController
  def unpaid
    sql = <<-SQL
      SELECT DISTINCT email from
      ( SELECT applicants.tckn FROM
        ( SELECT applicants.tckn FROM
            (Applicants
            INNER JOIN receipts
            ON applicants.id=receipts.applicant_id)
          GROUP BY applicants.tckn
          HAVING COUNT(CASE WHEN receipts.is_paid=true THEN 1 END) < 1
        ) t
        JOIN applicants ON applicants.tckn = t.tckn
        GROUP BY applicants.tckn
        HAVING COUNT(CASE WHEN applicants.applicant_type='presenter' THEN 1 END) < 1
      ) t2
      JOIN applicants ON applicants.tckn = t2.tckn;
    SQL

    @applicants = ActiveRecord::Base.connection.execute(sql)
  end

  def unpaid_all
    sql = <<-SQL
      SELECT DISTINCT email from
      ( SELECT applicants.tckn FROM
        ( SELECT applicants.tckn FROM
            (Applicants
            LEFT JOIN receipts
            ON applicants.id=receipts.applicant_id)
          GROUP BY applicants.tckn
          HAVING COUNT(CASE WHEN receipts.is_paid=true THEN 1 END) < 1
        ) t
        JOIN applicants ON applicants.tckn = t.tckn
        GROUP BY applicants.tckn
        HAVING COUNT(CASE WHEN applicants.applicant_type='presenter' THEN 1 END) < 1
      ) t2
      JOIN applicants ON applicants.tckn = t2.tckn;
    SQL

    @applicants = ActiveRecord::Base.connection.execute(sql)

    @emails = @applicants.map{ |e| e['email'] }
    @emails = @emails - Applicant.where(tckn: Applicant.where(email: @emails).uniq.pluck(:tckn), applicant_type: 'presenter').uniq.pluck(:email)
    @emails = @emails - Applicant.joins(:receipts).where(tckn: Applicant.where(email: @emails).uniq.pluck(:tckn), receipts: {is_paid: true}).uniq.pluck(:email)

    self.unpaid

    @emails = @emails - @applicants.map{|e|e['email']}
  end

  def get_applicants_as_word

    # applicants=Applicant.joins(:receipts, :card_numbers).where(:receipts=>{:is_paid=>true})

    cards=CardNumber.all

    template = Sablon.template(File.expand_path("public/applicants_template.docx"))
    context = {applicants:[]}

    cards.each_with_index  do |card, index|
      currentApplicant={
          index:index+1,
          id:card.id,
          name:card.applicant.name,
          surname:card.applicant.surname,
          occupation:card.applicant.occupation
      }

      context[:applicants].push(currentApplicant)
    end



    data=template.render_to_string context

    send_data data, :filename => " Kongre Katılımcılar Listesi.docx"
  end

end



