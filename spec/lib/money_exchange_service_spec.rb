require 'spec_helper'
require 'money_exchange_service'

RSpec.describe MoneyExchangeService do
  describe '#to' do
    context 'when the provided currencies are valid' do
      it 'should convert 20 dollars to 16 euros' do
        dollars = Money.new(currency: :usd, amount: 20)
        euros = described_class.new(dollars).to(:eur)

        expect(euros.currency).to be(:eur)
        expect(euros.amount).to eq(16)
      end

      it 'should convert 41.08 reais to 13 dollars' do
        reais = Money.new(currency: :brl, amount: 41.08)
        dollars = described_class.new(reais).to(:usd)

        expect(dollars.currency).to be(:usd)
        expect(dollars.amount).to eq(13)
      end

      it 'should convert 8 euros to 31.6 reais' do
        euros = Money.new(currency: :eur, amount: 8)
        reais = described_class.new(euros).to(:brl)

        expect(reais.currency).to be(:brl)
        expect(reais.amount).to eq(31.6)
      end

      it 'should convert 712.99 reais to euros and then to reais (.6f)' do
        from_reais = Money.new(currency: :brl, amount: 712.99)
        euros      = described_class.new(from_reais).to(:eur)
        to_reais   = described_class.new(euros).to(:brl)
        precision  = '%.6f'

        expect(to_reais.currency).to eq(:brl)
        expect(format(precision, to_reais.amount)).to eq(format(precision, from_reais.amount))
      end
    end

    context 'when the are provided invalid currencies' do
      it 'should raise Error::InvalidCurrencyError' do
        dollars = Money.new(currency: :usd, amount: 20)

        expect { described_class.new(dollars).to(:invalid_currency) }
          .to raise_error(Error::InvalidCurrencyError)
      end
    end
  end
end
