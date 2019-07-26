class KongreMailer < ActionMailer::Base
  default from: 'Türkiye Zeka Vakfı <info@tzv.org.tr>'

  def payment_accepted(receipt)
    @receipt = receipt
    mail(to: receipt.applicant.email, subject: 'Ödemeniz Onaylandı')
  end

  def test_mail(address)
    mail(to: address, subject: 'Deneme Maili')
  end

  def attendance_info_mail(email, card_number, workshops)

    @card_number = card_number
    @workshops = workshops

    mail(to: email, subject: 'VII. ZEKA ve YETENEK KONGRESİ #BenBilmemBeyinBilir')
  end

  def attendance_info_mail_ncn(email)
    mail(to: email, subject: 'V. ZEKA ve YETENEK KONGRESİ #kafakafaya')
  end

  def send_coupon_mail(email, code)
    @code = code
    mail(:to => email, :subject => 'Kongre Katılım Bedeli İndirim Kuponu')
  end

  def free_order_accepted(receipt)
    @receipt = receipt
    mail(to: receipt.applicant.email, subject: 'Başvurunuz Onaylandı')
  end

  def daily_info_mail(email)
    @receipts = Receipt.where(:is_paid => true).where("created_at > ? and created_at < ?", Date.today.beginning_of_day, Date.today.end_of_day)
    start_of_this_season = Date.new(2019,7,17)
    start_of_previous_season = Date.new(2018,7,3)
    @diff = (Date.today - start_of_this_season).to_i
    @receipts_this_year_sum = Receipt.where(:is_paid => true).where("created_at > ? and created_at < ?", start_of_this_season.beginning_of_day, Date.today.end_of_day).count
    @receipts_previous_year_today = Receipt.where(:is_paid => true).where("created_at > ? and created_at < ?", (start_of_previous_season + @diff.days).beginning_of_day, (start_of_previous_season + @diff.days).end_of_day).count
    @receipts_previous_year_sum = Receipt.where(:is_paid => true).where("created_at > ? and created_at < ?", start_of_previous_season.beginning_of_day, (start_of_previous_season + @diff.days).end_of_day).count
    @total = @receipts.sum(:price) / 100
    mail(to: email, subject: 'Kongre - Günlük Bilgilendirme')
  end
end
