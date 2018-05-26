require_relative 'money'

class Wallet
  attr_reader :name, *Money::CURRENCY_SYMBOLS

  def initialize(args)
    @name = args.fetch(:name)
    initialize_currencies(args)
  end

  def wallets
    wallets = Hash[Money::CURRENCY_SYMBOLS.collect(&currency_and_amount_pair)]
    wallets.reject { |currency, amount| amount.nil? }
  end

  def to_credit(currency)
    send(currency) || first_present_currency_on_wallet
  end

  def to_debit(currency)
    send(currency)
  end

  private

  def initialize_currencies(currencies)
    Money::CURRENCY_SYMBOLS.each do |currency|
      amount = currencies[currency]

      next if amount.nil?

      money = Money.new(currency: currency, amount: amount)
      instance_variable_set("@#{currency}", money)
    end
  end

  def currency_and_amount_pair
    @currency_and_amount_pair ||= -> (k) { [k, send(k)&.human_amount] }
  end

  def first_present_currency_on_wallet
    found_currency = Money::CURRENCY_SYMBOLS.find { |currency| send(currency) }

    found_currency && send(found_currency)
  end
end
