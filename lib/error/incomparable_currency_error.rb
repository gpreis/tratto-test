require_relative 'custom_error'
require_relative '../money'

module Error
  class IncomparableCurrencyError < CustomError
    def initialize
      super('The currency must be the same to compare money!')
    end
  end
end
