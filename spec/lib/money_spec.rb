require 'spec_helper'
require 'bigdecimal'
require 'money'

RSpec.describe Money do
  describe '#initialize' do
    context 'when the amount is not provided' do
      it 'should raise KeyError' do
        params = { currency: :brl }

        expect { Money.new(params) }.to raise_error(KeyError)
      end
    end

    context 'when the provided amount is informed' do
      it 'transform it to bigdecimal' do
        params = { amount: 42, currency: :usd }
        money = Money.new(params)

        expect(money.amount).to be_a BigDecimal
        expect(money.amount).to eq 42
      end
    end

    context 'when the currency is not provided' do
      it 'should raise KeyError' do
        params = { amount: 42 }

        expect { Money.new(params) }.to raise_error(KeyError)
      end
    end

    context 'when the provided currency is invalid' do
      it 'should raise InvalidCurrencyError' do
        params = { amount: 42, currency: :invalid }

        expect { Money.new(params) }.to raise_error(Error::InvalidCurrencyError)
      end
    end
  end

  describe 'comparable' do
    context 'when compare two different currencies' do
      it 'should raise IncomparableCurrencyError' do
        one     = Money.new(currency: :usd, amount: 42)
        another = Money.new(currency: :brl, amount: 42)

        expect { one <=> another }.to raise_error(Error::IncomparableCurrencyError)
      end
    end

    context 'when compare the same currency' do
      it 'should call the amount comparable' do
        amount  = double
        one     = Money.new(currency: :usd, amount: 42)
        another = Money.new(currency: :usd, amount: 37)

        allow(one).to receive(:amount) { amount }
        expect(amount).to receive(:<=>)

        one <=> another
      end
    end
  end

  describe '#credit' do
    context 'when is passed the same currency' do
      it 'should credit the amount' do
        money = Money.new(currency: :eur, amount: 50)
        deposit = Money.new(currency: :eur, amount: 12)

        expect { money.credit(deposit) }.to change { money.amount }.by(deposit.amount)
      end
    end
  end

  describe '#debit' do
    context 'when is passed the same currency' do
      it 'should debit the amount' do
        money = Money.new(currency: :eur, amount: 50)
        withdraw = Money.new(currency: :eur, amount: 12)

        expect { money.debit(withdraw) }.to change { money.amount }.by(-withdraw.amount)
      end
    end
  end
end
