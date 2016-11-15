class KongreMailer < ActionMailer::Base
  default from: 'Türkiye Zeka Vakfı <info@tzv.org.tr>'

  def payment_accepted(receipt)
    @receipt = receipt
    mail(to: receipt.applicant.email, subject: 'Ödemeniz Onaylandı')
  end

  def test_mail(address)
    mail(to: address, subject: 'Deneme Maili')
  end

  def attendance_info_mail(applicant)
    @name = "#{applicant.name} #{applicant.surname}"
    @card_number = applicant.card_number.id
    @workshops = applicant.paid_workshops.map { |w| w.product.name }

    mail(to: applicant.email, subject: 'Aklını Kullan, #KorkmaBitmez')
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
    @total = @receipts.sum(:price) / 100
    mail(to: email, subject: 'Kongre - Günlük Bilgilendirme')
  end
end
