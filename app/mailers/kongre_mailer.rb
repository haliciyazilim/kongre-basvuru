class KongreMailer < ActionMailer::Base
  default from: 'info@tzv.org.tr'
  def payment_accepted(receipt)
    @receipt = receipt
    mail(to:receipt.applicant.email, subject: 'Ödemeniz Onaylandı')
  end
end
