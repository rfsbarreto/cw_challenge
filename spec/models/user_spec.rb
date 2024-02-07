require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it { should have_many(:transactions) }
  end

  describe '.transaction_amount_limit' do
    subject(:transaction_amount_limit) { user.transaction_amount_limit }
    let(:user) { create(:user, max_transaction_amount: max_amount) }

    context 'when user has max_transaction_amount set up' do
      let(:max_amount) { 10_000 }

      it { expect(transaction_amount_limit).to eq max_amount }
    end

    context 'when user has max_transaction_amount set up' do
      let(:max_amount) { nil }

      it { expect(transaction_amount_limit).to eq ENV['DEFAULT_MAX_TRANSACTION_AMOUNT'].to_f }
    end
  end
end
