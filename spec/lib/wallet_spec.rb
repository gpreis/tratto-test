require 'spec_helper'
require 'wallet'

RSpec.describe Wallet do
  describe '#initialize' do
    context 'when the name is not provided' do
      it 'should fail' do
        params = { brl: 42 }

        expect { Wallet.new(params) }.to raise_error(KeyError)
      end
    end

    context 'when amounts are provided' do
      let(:params) { { name: 'jon', brl: 42, tst: 2} }
      let(:wallet) { Wallet.new(params) }

      it 'should create a wallet for each valid one' do
        brl = Money.new(currency: :brl, amount: 42)

        expect(wallet.brl).to eq brl
      end

      it 'should return nil for not provided amounts' do
        expect(wallet.usd).to be_nil
      end

      it 'should ignore invalid currencies' do
        expect(wallet).to_not respond_to(:tst)
      end
    end
  end

  describe '#wallets' do
    let(:params) { { name: 'jon', eur: 42, usd: 71 } }
    let(:wallet) { Wallet.new(params) }
    subject { wallet.wallets }

    it 'should include the non nil currencies and their amounts' do
      expect(subject).to include(usd: 71)
      expect(subject).to include(eur: 42)
    end

    it 'should not included empty ones' do
      expect(subject.keys).to_not include(:brl)
    end
  end
end
