require 'spec_helper'
require 'wallet_central'

RSpec.describe WalletCentral do
  describe '#transfer' do
    context 'when there is enough balance' do
      context 'when both wallet have the transfered currency' do
        let(:sender)   { Wallet.new(name: 'jon', usd: 20) }
        let(:receiver) { Wallet.new(name: 'paul', usd: 7) }
        let(:amount)   { 9 }
        subject { WalletCentral.transfer(sender, receiver, 'USD', amount) }

        it 'should subtract the amount from the sender' do
          expect { subject }.to change { sender.usd.amount }.by(-amount)
        end

        it 'should add the amount to the receiver' do
          expect { subject }.to change { receiver.usd.amount }.by(amount)
        end
      end
    end

    context 'when the try to transfer an invalid currency' do
      it 'should raise Error::InvalidCurrencyError' do
        expect { WalletCentral.transfer(nil, nil, 'OPS', 231) }
          .to raise_error(Error::InvalidCurrencyError)
      end
    end

    context 'when the sender does not have enough funds' do
      it 'should raise Error::InvalidCurrencyError' do
        john = Wallet.new(name: 'john', usd: 5)
        paul = Wallet.new(name: 'paul', usd: 5)

        expect { WalletCentral.transfer(john, paul, 'USD', '5.01') }
          .to raise_error(Error::InsufficientFundsError)
      end
    end

    context 'when the sender not have the transfered currency' do
      it 'should raise Error::MissingDebitWalletError' do
        john = Wallet.new(name: 'john', usd: 5)
        paul = Wallet.new(name: 'paul', usd: 5)

        expect { WalletCentral.transfer(john, paul, 'BRL', '5.01') }
          .to raise_error(Error::MissingDebitWalletError)
      end
    end

    context 'when the receiver does not have any currency' do
      it 'should raise Error::MissingCreditWalletError' do
        john = Wallet.new(name: 'john', usd: 5)
        paul = Wallet.new(name: 'paul')

        expect { WalletCentral.transfer(john, paul, 'USD', 2) }
          .to raise_error(Error::MissingCreditWalletError)
      end
    end
  end
end
