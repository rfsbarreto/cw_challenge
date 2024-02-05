require_relative '../rails_helper'

RSpec.describe TransactionsController, type: :controller do
  let(:transaction_params) do
    {
      transaction_id: 2_342_357,
      merchant_id: 29_744,
      user_id: 97_051,
      card_number: '434505******9116',
      transaction_date: '2019-11-31T23:16:32.812632',
      transaction_amount: 373,
      device_id: 285_475
    }
  end

  describe '#create' do
    let(:make_request) { post :create, params: transaction_params }

    before { make_request }

    context 'when params are valid' do
      context 'when user and merchant exists' do
        it 'returns http success' do
          expect(response).to have_http_status(:success)

          expect(JSON.parse(response.body))
            .to eq({ 'transaction_id' => transaction_params[:transaction_id], 'recommendation' => 'approved' })
        end

        context 'when merchant is blocked for transactions' do
        end

        context 'when user is blocked for transactions' do
        end

        context 'when user has exceeded transaction limit' do
        end
        
        context 'when user tried too many transactions under timeframe' do
        end

      end

      context 'when user doesnt exists' do
      end

      context 'when merchant doesnt exists' do
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

      it 'returns http success' do
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
