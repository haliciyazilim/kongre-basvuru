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
    # mail(to: email, subject: 'VII. ZEKA ve YETENEK KONGRESİ #BenBilmemBeyinBilir')
    mail(to: email, subject: 'VIII. ZEKA ve YETENEK KONGRESİ')
  end

  def attendance_info_mail_ncn(email)
    # mail(to: email, subject: 'V. ZEKA ve YETENEK KONGRESİ #kafakafaya')
    mail(to: email, subject: 'VIII. ZEKA ve YETENEK KONGRESİ')
  end

  def send_coupon_mail(email, code)
    @code = code
    # mail(:to => email, :subject => 'Kongre Katılım Bedeli İndirim Kuponu')
    mail(:to => email, :subject => 'VIII. ZEKA ve YETENEK KONGRESİ Katılım Bedeli İndirim Kuponu')
  end

  def free_order_accepted(receipt)
    @receipt = receipt
    mail(to: receipt.applicant.email, subject: 'Başvurunuz Onaylandı')
  end

  def daily_info_mail(email)
    @receipts = Receipt.where(:is_paid => true).where("created_at > ? and created_at < ?", (Date.today.beginning_of_day - 7.hours), Date.today.end_of_day)
    start_of_this_season = Date.new(2022,9,22)
    start_of_previous_season = Date.new(2019,7,17)
    @diff = (Date.today - start_of_this_season).to_i
    # 42 is the id of 2022 zirve kongre katılım id
    # TODO: it should be change next year or refaktor now
    @kongre_today_count = 0
    @receipts.each do |receipt|
      @kongre_today_count += receipt.receipt_products.where(:product_id=>42).count
    end
    @atolye_today_count = 0
    @receipts.each do |receipt|
      @atolye_today_count += receipt.receipt_products.where.not(:product_id=>42).count
    end
    @receipts_this_year_sum = Receipt.where(:is_paid => true).where("created_at > ? and created_at < ?", start_of_this_season.beginning_of_day, Date.today.end_of_day).count
    @receipts_previous_year_today = Receipt.where(:is_paid => true).where("created_at > ? and created_at < ?", (start_of_previous_season + @diff.days).beginning_of_day, (start_of_previous_season + @diff.days).end_of_day).count
    @receipts_previous_year_sum = Receipt.where(:is_paid => true).where("created_at > ? and created_at < ?", start_of_previous_season.beginning_of_day, (start_of_previous_season + @diff.days).end_of_day).count
    @total = @receipts.sum(:price) / 100
    # mail(to: email, subject: 'Kongre - Günlük Bilgilendirme')
    mail(to: email, subject: 'Kongre - Günlük Bilgilendirme')
  end
end
