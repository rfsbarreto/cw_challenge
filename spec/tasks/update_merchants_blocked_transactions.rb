require 'rails_helper'
require 'rake'

describe 'merchant:update_merchants_blocked_transactions' do
  let(:merchant) { create(:merchant, number_chargebacks: number_of_chargebacks) }
  let!(:chargebacked_transactions) { create_list(:transaction, number_of_chargebacks, merchant:, chargebacked: true) }
  let!(:non_chargebacked_transactions) do
    create_list(:transaction, number_of_non_chargebacks, merchant:, chargebacked: true)
  end

  before :all do
    Rake.application.rake_require 'tasks/update_merchants_blocked_transactions'
    Rake::Task.define_task(:environment)
  end

  context 'when percentage is more than 30% and number of transactions > 10' do
    let(:number_of_chargebacks) { 10 }
    let(:number_of_non_chargebacks) { 20 }

    it 'updates block_transactions attribute' do
      # Run the Rake task
      Rake::Task['merchant:update_merchants_blocked_transactions'].invoke

      merchant.reload

      expect(merchant.block_transactions?).to eq(true)
    end
  end
  context 'when percentage is less than 30%' do
    let(:number_of_chargebacks) { 4 }
    let(:number_of_non_chargebacks) { 20 }

    it 'doesnt updates block_transactions attribute' do
      # Run the Rake task
      Rake::Task['merchant:update_merchants_blocked_transactions'].invoke

      merchant.reload

      expect(merchant.block_transactions?).to eq(false)
    end
  end
  context 'when percentage is number of transactions < 10' do
    let(:number_of_chargebacks) { 2 }
    let(:number_of_non_chargebacks) { 2 }

    it 'doesnt updates block_transactions attribute' do
      # Run the Rake task
      Rake::Task['merchant:update_merchants_blocked_transactions'].invoke

      merchant.reload

      expect(merchant.block_transactions?).to eq(false)
    end
  end
end
