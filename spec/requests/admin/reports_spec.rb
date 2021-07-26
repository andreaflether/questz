require 'rails_helper'

RSpec.describe "Admin::Reports", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/admin/reports/index"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /show" do
    it "returns http success" do
      get "/admin/reports/show"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /assign" do
    it "returns http success" do
      get "/admin/reports/assign"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /close" do
    it "returns http success" do
      get "/admin/reports/close"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /solve" do
    it "returns http success" do
      get "/admin/reports/solve"
      expect(response).to have_http_status(:success)
    end
  end

end
