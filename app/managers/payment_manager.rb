class PaymentManager
  def self.token; ENV['PAYMENT_TOKEN'] end

  def self.host; 'http://localhost:3000' end

  def self.payment_connector
    payment_connector = HaliciPaymentConnector.new
    payment_connector.host = self.host
    payment_connector.token = token
    payment_connector
  end

  def self.checkout(params)
    params[:token] = token
    params[:success_callback] = 'http://localhost:1234/callback/success'
    params[:error_callback] = 'http://localhost:1234/callback/error'
    payment_connector.checkout(params)
  end

  def self.check(payment_id)
    payment_connector.check(payment_id)
  end

end