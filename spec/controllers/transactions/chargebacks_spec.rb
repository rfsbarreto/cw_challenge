require 'rails_helper'

RSpec.describe "Transactions::Chargebacks", type: :request do
  describe "GET /create" do
    it "returns http success" do
      get "/transactions/chargebacks/create"
      expect(response).to have_http_status(:success)
    end
  end

end
