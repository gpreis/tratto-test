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

  describe '#to_credit' do
    context 'when the wallet has the requested currency wallet' do
      it 'should return it' do
        params = { name: 'jon', eur: 71 }
        wallet = Wallet.new(params)
        eur    = Money.new(currency: :eur, amount: 71)

        expect(wallet.to_credit(:eur)).to eq eur
      end
    end

    context 'when the wallet doenst have the requested currency wallet' do
      it 'should return the first that is found on the wallet' do
        params = { name: 'jon', brl: 71 }
        wallet = Wallet.new(params)
        brl    = Money.new(currency: :brl, amount: 71)

        expect(wallet.to_credit(:usd)).to eq brl
      end
    end

    context 'when wallet is empty' do
      it 'should return nil' do
        params = { name: 'jon' }
        wallet = Wallet.new(params)

        expect(wallet.to_credit(:usd)).to be_nil
      end
    end
  end

  describe '#to_debit' do
    context 'when the wallet has the requested currency wallet' do
      it 'should return it' do
        params = { name: 'jon', eur: 71 }
        wallet = Wallet.new(params)
        eur    = Money.new(currency: :eur, amount: 71)

        expect(wallet.to_debit(:eur)).to eq eur
      end
    end

    context 'when the wallet doenst have the requested currency wallet' do
      it 'should return the first that is found on the wallet' do
        params = { name: 'jon', brl: 71 }
        wallet = Wallet.new(params)

        expect(wallet.to_debit(:usd)).to be_nil
      end
    end
  end
end
