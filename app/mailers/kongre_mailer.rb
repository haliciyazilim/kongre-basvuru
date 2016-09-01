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

    mail(to: applicant.email, subject: 'Hep beraber soralım: BeyinSizMisiniz?')
  end

  def send_coupon_mail(email)
    @coupon = Coupon.where(:season => ApplicationController.calculate_season, :used_at => nil, :email => email).first

    mail(:to => email, :subject => 'Türkiye Zeka Vakfı - Kongre Katılım Bedeli İndirim Kuponu')
  end

  def free_order_accepted(receipt)
    @receipt = receipt
    mail(to: receipt.applicant.email, subject: 'Başvurunuz Onaylandı')
  end
end
