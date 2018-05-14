class Wallet
  attr_reader :currency, :amount

  def initialize(attributes)
    @currency = attributes.fetch(:currency)
    @amount   = attributes.fetch(:amount, 0)
  end
end
