
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
  end
end
