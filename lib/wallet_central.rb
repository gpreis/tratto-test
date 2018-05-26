require_relative 'error/missing_debit_wallet_error'
require_relative 'error/missing_credit_wallet_error'
require_relative 'money'

class WalletCentral
  def self.transfer(from_wallet, to_wallet, currency, amount)
    money = Money.new currency: currency_to_symbol(currency), amount: amount

    WalletCentral.new(from_wallet, to_wallet, money).send(:transfer)
  end

  def self.currency_to_symbol(currency)
    currency.to_s.downcase.to_sym
  end

  private

  attr_reader :from_wallet, :to_wallet, :money_transaction

  def initialize(from_wallet, to_wallet, money_transaction)
    @from_wallet       = from_wallet
    @to_wallet         = to_wallet
    @money_transaction = money_transaction
  end

  def transfer
    verify_debit_wallet!
    verify_credit_wallet!
    debit!
    credit!
  end

  def verify_debit_wallet!
    return unless from_money.nil?

    raise Error::MissingDebitWalletError,
          wallet: from_wallet,
          currency: currency
  end

  def verify_credit_wallet!
    return unless to_money.nil?

    raise Error::MissingCreditWalletError,
          wallet: to_wallet,
          currency: currency
  end

  def debit!
    from_money.debit(money_transaction)
  end

  def credit!
    to_money.credit(money_transaction)
  end

  def from_money
    @from_money = from_wallet.to_debit(currency)
  end

  def to_money
    @to_money = to_wallet.to_credit(currency)
  end

  def currency
    money_transaction.currency
  end
end
