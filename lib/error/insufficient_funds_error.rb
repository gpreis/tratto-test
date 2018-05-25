require_relative 'custom_error'
require_relative '../money'

module Error
  class InsufficientFundsError < CustomError
    def initialize(withdraw = nil)
      text = withdraw.nil? ? 'enough' : format('%.6f', withdraw.amount)

      super("You do not have #{text} to debit!")
    end
  end
end
