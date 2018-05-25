require_relative 'custom_error'
require_relative '../money'

module Error
  class InvalidCurrencyError < CustomError
    def initialize(currency = 'The informed currency')
      super("#{currency} is not valid. Use one of #{Money::CURRENCY_SYMBOLS}")
    end
  end
end
