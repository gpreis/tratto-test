require_relative 'custom_error'
require_relative '../money'

module Error
  class MissingCreditWalletError < CustomError
    def initialize(wallet:, currency:)
      name = wallet.name

      super("The #{name} does not have a #{currency} wallet or any at all!")
    end
  end
end
