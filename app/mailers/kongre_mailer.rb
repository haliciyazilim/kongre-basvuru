class KongreMailer < ActionMailer::Base
  default from: 'Türkiye Zeka Vakfı <info@tzv.org.tr>'
  def payment_accepted(receipt)
    @receipt = receipt
    mail(to:receipt.applicant.email, subject: 'Ödemeniz Onaylandı')
  end
end
