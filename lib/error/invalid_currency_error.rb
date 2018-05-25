require_relative 'custom_error'
require_relative '../money'

module Error
  class InvalidCurrencyError < CustomError
    def initialize(currency = 'informed currency')
      super("The #{currency} is invalid. Use one of #{Money::CURRENCY_SYMBOLS}")
    end
  end
end
