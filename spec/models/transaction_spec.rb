require 'rails_helper'

RSpec.describe Transaction, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:merchant_id) }
    it { should validate_presence_of(:user_id) }
    it { should validate_presence_of(:card_number) }
    it { should validate_presence_of(:transaction_date) }
    it { should validate_presence_of(:transaction_amount) }
  end

  describe 'associations' do
    it {  }
  end

  describe '#by_user' do
    let(:user) { create(:user) }
    let!(:transaction) { create(:transaction, user_id: user.id) }
    let!(:other_transaction) { create(:transaction) }

    context 'when user exist' do
      it 'returns only transactions by the passed user' do
        expect(Transaction.by_user(user.id)).to match [transaction]
      end
    end

    context 'when user doesnt exist' do
      it { expect(Transaction.by_user(-1)).to be_empty }
    end
  end

  describe '.number_of_transactions_by_timeframe' do
    subject(:number_of_transactions_by_timeframe) do
      Transaction.number_of_transactions_by_timeframe(time_in_seconds: 66.minutes)
    end
    let!(:transaction1) { create(:transaction, transaction_date: 1.hour.ago) }
    let!(:transaction2) { create(:transaction, transaction_date: 2.hours.ago) }
    let!(:transaction3) { create(:transaction, transaction_date: 3.hours.ago) }

    it 'returns 1' do
      expect(number_of_transactions_by_timeframe).to eq 1
    end
  end

  describe '#recommendation' do
    let(:approved_transaction) { create(:transaction, approved: true) }
    let(:denied_transaction) { create(:transaction, approved: false) }

    it 'returns "approved" for approved transactions' do
      expect(approved_transaction.recommendation).to eq('approved')
    end

    it 'returns "denied" for denied transactions' do
      expect(denied_transaction.recommendation).to eq('denied')
    end
  end
end
