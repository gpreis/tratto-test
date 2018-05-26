require_relative 'custom_error'
require_relative '../money'

module Error
  class MissingDebitWalletError < CustomError
    def initialize(wallet:, currency:)
      super("The #{wallet.name} does not have a #{currency} wallet!")
    end
  end
end
