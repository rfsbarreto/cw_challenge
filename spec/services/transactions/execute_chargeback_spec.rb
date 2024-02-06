require 'rails_helper'

RSpec.describe Transactions::ExecuteChargeback do
  let(:transaction) { create(:transaction) }
  let(:transaction_id) { transaction.id }
  let(:chargebacked) { true }
  let(:user) { transaction.user }
  let(:merchant) { transaction.merchant }

  subject(:execute_chargeback) { Transactions::ExecuteChargeback.new(transaction_id:, chargebacked:) }

  context 'when the service object runs successfully' do
    it 'returns true' do
      expect(execute_chargeback.run).to eq(true)
    end

    it 'updates the transaction chargebacked attribute to true' do
      expect { execute_chargeback.run }.to change { transaction.reload.chargebacked }.from(false).to(true)
    end

    it 'updates the user block_transactions attribute to true' do
      expect { execute_chargeback.run }.to change { user.reload.block_transactions }.from(false).to(true)
    end

    it 'increments the merchant number_chargebacks by 1' do
      expect { execute_chargeback.run }.to change { merchant.reload.number_chargebacks }.by(1)
    end
  end

  context 'when the service object fails' do
    let(:transaction_id) { -1 }

    it 'returns false' do
      expect(execute_chargeback.run).to eq(false)
    end

    it 'does not update the transaction chargebacked attribute' do
      expect { execute_chargeback.run }.not_to(change { transaction.reload.chargebacked })
    end

    it 'does not update the user block_transactions attribute' do
      expect { execute_chargeback.run }.not_to(change { user.reload.block_transactions })
    end

    it 'does not increment the merchant number_chargebacks' do
      expect { execute_chargeback.run }.not_to(change { merchant.reload.number_chargebacks })
    end
  end
end
