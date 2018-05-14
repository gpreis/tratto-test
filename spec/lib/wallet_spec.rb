require 'spec_helper'
require 'wallet'

RSpec.describe Wallet do
  describe '#initialize' do
    context 'when the currency is provided' do
      it 'should create a new Wallet' do
        params = { currency: 'USD' }
        wallet = Wallet.new(params)

        expect(wallet).to be_a Wallet
      end
    end

    context 'when the currency is not provided' do
      it 'should fail' do
        params = { amount: 42 }

        expect { Wallet.new(params) }.to raise_error(KeyError)
      end
    end
  end
end
