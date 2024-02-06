require 'rails_helper'

RSpec.describe TransactionsController, type: :controller do
  let(:transaction_params) do
    {
      transaction_id: 2_342_357,
      merchant_id: merchant.id,
      user_id: user.id,
      card_number: '434505******9116',
      transaction_date: Time.now,
      transaction_amount:,
      device_id: 285_475
    }
  end

  describe '#create' do
    let(:make_request) { post :create, params: transaction_params }
    let(:user) { create(:user) }
    let(:merchant) { create(:merchant) }
    let(:transaction_amount) { 300 }
    let(:create_transactions) {}

    shared_examples 'returns a denied transaction' do
      it 'returns a denied transaction' do
        expect(JSON.parse(response.body))
          .to eq({ 'transaction_id' => transaction_params[:transaction_id], 'recommendation' => 'denied' })
      end
    end

    before do
      create_transactions

      make_request
    end

    context 'when params are valid' do
      it 'returns http created' do
        expect(response).to have_http_status(:success)
      end

      context 'when user and merchant exists and FraudCheck clear transaction' do
        it 'returns a approved transaction' do
          expect(JSON.parse(response.body))
            .to eq({ 'transaction_id' => transaction_params[:transaction_id], 'recommendation' => 'approved' })
        end
      end

      context 'when merchant is blocked for transactions' do
        let(:merchant) { create(:merchant, block_transactions: true) }

        it_behaves_like 'returns a denied transaction'
      end

      context 'when user is blocked for transactions' do
        let(:user) { create(:user, block_transactions: true) }

        it_behaves_like 'returns a denied transaction'
      end

      context 'when user has exceeded transaction limit' do
        let(:user) { create(:user, max_transaction_amount: transaction_amount - 1) }
        it_behaves_like 'returns a denied transaction'
      end

      context 'when user tried too many transactions under timeframe' do
        let(:create_transactions) do
          create_list(:transaction, 4, transaction_date: transaction_params[:transaction_date] - 10.seconds, user:)
        end

        it_behaves_like 'returns a denied transaction'
      end

      context 'when user doesnt exists' do
        let(:user) { Struct.new(:id).new(Faker::Number.number) }

        it 'creates one' do
          expect(User.find(user.id)).to be_present
        end
      end

      context 'when merchant doesnt exists' do
        let(:merchant) { Struct.new(:id).new(Faker::Number.number) }

        it 'creates one' do
          expect(Merchant.find(merchant.id)).to be_present
        end
      end
    end

    context 'when params are invalid' do
      let(:transaction_params) do
        {
          transaction_id: 2_342_357,
          merchant_id: 29_744,
          card_number: '434505******9116',
          transaction_date: '2019-11-31T23:16:32.812632',
          device_id: 285_475
        }
      end

      it 'returns unprocessable_entity' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'fill errors correctly' do
        expected_errors = { 'errors' => ['User must exist', 'User can\'t be blank', 'Transaction amount can\'t be blank']}
        expect(JSON.parse(response.body)).to match expected_errors
      end
    end
  end
end
