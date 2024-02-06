require 'rails_helper'

RSpec.describe Transactions::CheckFraud, type: :model do
  let(:user) { build(:user) }
  let(:merchant) { build(:merchant) }
  let(:transaction) { build(:transaction, user:) }

  let(:fraud_check) { Transactions::FraudCheck.new(transaction:, user:, merchant:) }

  describe '#transaction_cleared?' do
    subject(:transaction_cleared?) { fraud_check.transaction_cleared? }

    context 'when user is not blocked and merchant is not blocked and transaction is not above limit and it hasnt too many transactions' do
      before do
        allow(user).to receive(:block_transactions?).and_return(false)
        allow(merchant).to receive(:block_transactions?).and_return(false)

        allow(fraud_check).to receive(:transaction_above_user_limit?).and_return(false)
        allow(fraud_check).to receive(:too_much_transactions_within_timeframe?).and_return(false)
      end

      it 'returns true' do
        expect(transaction_cleared?).to eq(true)
      end
    end
    context 'when user blocks transactions' do
      before do
        allow(user).to receive(:block_transactions?).and_return(true)
      end

      it 'returns false' do
        expect(transaction_cleared?).to eq(false)
      end
    end

    context 'when merchant blocks transactions' do
      before do
        allow(merchant).to receive(:block_transactions?).and_return(true)
      end

      it 'returns false' do
        expect(transaction_cleared?).to eq(false)
      end
    end

    context 'when transaction is above user limit' do
      before do
        allow(fraud_check).to receive(:transaction_above_user_limit?).and_return(true)
      end

      it 'returns false' do
        expect(transaction_cleared?).to eq(false)
      end
    end

    context 'when user has too many transactions in the timeframe' do
      before do
        allow(fraud_check).to receive(:too_much_transactions_within_timeframe?).and_return(true)
      end

      it 'returns true' do
        expect(transaction_cleared?).to eq(false)
      end
    end
  end
end
