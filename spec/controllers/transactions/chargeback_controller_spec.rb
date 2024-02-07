# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Transactions::ChargebackController, type: :controller do
  describe '#create' do
    let(:make_request) { post :create, params: { id: transaction.id } }

    before do
      allow(controller).to receive(:authenticate).and_return(nil) # skip authentication for tests

      make_request
    end

    context 'when params are valid' do
      let(:transaction) { create(:transaction) }

      it 'returns created status' do
        expect(response).to have_http_status(:success)
      end
    end

    context 'when transaction doesnt exist' do
      let(:transaction) { Struct.new(:id).new(-1) }

      it 'returns unprocessable_entity status' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns errors' do
        expect(JSON.parse(response.body)).to eq({ 'errors' => ["Couldn't find Transaction with 'id'=#{transaction.id}"] })
      end
    end
  end
end
