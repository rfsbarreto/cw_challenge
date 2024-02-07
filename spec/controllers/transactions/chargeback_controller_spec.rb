# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Transactions::ChargebackController, type: :controller do
  describe '#create' do
    let(:make_request) { post :create, params: chargeback_params }

    before do
      allow(controller).to receive(:authenticate).and_return(nil) # skip authentication for tests

      make_request
    end

    context 'when params are valid' do
      let(:transaction) { create(:transaction) }
      let(:chargeback_params) { { transaction_id: transaction.id } }

      it 'returns created status' do
        expect(response).to have_http_status(:success)
      end
    end

    context 'when transaction doesnt exist' do
      let(:chargeback_params) { { transaction_id: -1 } }

      it 'returns created status' do
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
