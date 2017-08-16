class PaymentManager
  def self.token; ENV['PAYMENT_TOKEN'] end

  def self.host; ENV['PAYMENT_HOST'] end

  def self.payment_connector
    payment_connector = HaliciPaymentConnector.new
    payment_connector.host = self.host
    payment_connector.token = token
    payment_connector
  end

  def self.checkout(params)
    params[:token] = token
    params[:success_callback] = "#{params[:hostname]}/callback/success"
    params[:error_callback] = "#{params[:hostname]}/callback/error"
    payment_connector.checkout(params)
  end

  def self.check(payment_token)
    payment_connector.check(payment_token)
  end

end
