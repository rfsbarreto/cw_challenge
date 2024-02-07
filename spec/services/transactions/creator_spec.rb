require 'rails_helper'

RSpec.describe Transactions::Creator do
  let(:user) { create(:user) }
  let(:merchant) { create(:merchant) }
  let(:transaction_params) { attributes_for(:transaction, user_id: user.id, merchant_id: merchant.id) }

  describe '#run' do
    subject(:creator) { described_class.new(transaction_params:) }

    context 'when transaction is valid' do
      it 'creates a new transaction and increments user and merchant transactions' do
        expect { creator.run }
          .to(change(Transaction, :count).by(1))

        expect(creator.transaction).to be_present
        expect(creator.errors).to be_nil
      end

      it 'increments user and merchant transactions' do
        expect { creator.run }.to change { user.reload.number_transactions }.by(1)
      end

      it 'increments merchant transactions' do
        expect { creator.run }.to change { merchant.reload.number_transactions }.by(1)
      end

      it 'approves the transaction if it passes fraud check' do
        allow_any_instance_of(Transactions::CheckFraud).to receive(:transaction_cleared?).and_return(true)

        creator.run

        expect(creator.transaction.approved).to be_truthy
      end
    end

    context 'when transaction is invalid' do
      before do
        transaction_params[:transaction_amount] = nil # Make the transaction invalid
      end

      it 'does not create a new transaction and returns errors' do
        creator.run
        expect(creator.transaction).to be_nil
        expect(creator.errors).to include("Transaction amount can't be blank")
      end
    end

    context 'when an error occurs during transaction creation' do
      it 'logs the error and returns false' do
        allow(ActiveRecord::Base).to receive(:transaction).and_raise(StandardError, 'Some error')

        expect(Rails.logger).to receive(:error).with(/Some error/)
        expect(creator.run).to be_falsey
      end
    end
  end
end
