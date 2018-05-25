require_relative 'money'

class MoneyExchangeService
  attr_reader :money

  BASE_CURRENCY = :usd
  EXCHANGE_RATES = {
    usd: 1.00,
    brl: 3.16,
    eur: 0.80
  }.freeze

  def initialize(money)
    @money = money
  end

  def to(currency)
    Money.new currency: currency, amount: amount_to(currency)
  end

  private

  def rates(currency)
    EXCHANGE_RATES[currency] || 0
  end

  def in_base_currency
    @in_base_currency ||= money.raw_amount / rates(money.currency)
  end

  def amount_to(currency)
    case currency
    when money.currency
      money.raw_amount
    when BASE_CURRENCY
      in_base_currency
    else
      in_base_currency * rates(currency)
    end
  end
end
