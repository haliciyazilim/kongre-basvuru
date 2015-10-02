class Admin::ApplicantsController < AdminController
  def unpaid
    sql = <<-SQL
      SELECT * FROM
      ( SELECT applicants.tckn FROM (Applicants
        INNER JOIN receipts
        ON applicants.id=receipts.applicant_id)
        GROUP BY applicants.tckn
        HAVING COUNT(CASE WHEN receipts.is_paid=true THEN 1 END) < 1 ) t
      JOIN applicants ON applicants.tckn = t.tckn
      ORDER BY applicants.tckn;
    SQL

    @applicants = ActiveRecord::Base.connection.execute(sql)
  end
end