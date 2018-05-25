require_relative 'error/insufficient_funds_error'
require_relative 'error/invalid_currency_error'
require_relative 'error/incomparable_currency_error'
require_relative 'money_exchange_service'
require 'bigdecimal'

class Money
  include Comparable

  CURRENCY_SYMBOLS = %i[usd eur brl].freeze
  BIG_DECIMALS     = 16
  DECIMALS         = 4
  HUMAN_DECIMALS   = 2

  attr_reader :currency

  def initialize(args)
    @currency = args.fetch(:currency)
    @amount = BigDecimal(args.fetch(:amount), BIG_DECIMALS)

    validate_currency!
  end

  def credit(money)
    converted = convert_to_self_currency(money)

    @amount += converted.amount
  end

  def debit(money)
    converted = convert_to_self_currency(money)
    raise(Error::InsufficientFundsError, converted) if self < converted

    @amount -= converted.amount
  end

  def <=>(other)
    raise Error::IncomparableCurrencyError unless currency == other.currency
    amount <=> other.amount
  end

  def human_amount
    amount.floor(HUMAN_DECIMALS).to_f
  end

  def amount
    @amount.floor(DECIMALS)
  end

  def raw_amount
    @amount
  end

  private

  def validate_currency!(currency = @currency)
    return if CURRENCY_SYMBOLS.include? currency
    raise Error::InvalidCurrencyError
  end

  def convert_to_self_currency(money)
    MoneyExchangeService.new(money).to(currency)
  end
end
