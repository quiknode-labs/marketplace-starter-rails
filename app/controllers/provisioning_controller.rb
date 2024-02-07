# frozen_string_literal: true

class ProvisioningController < ApplicationController
  respond_to :json

  # Authenticate with HTTP Basic Auth.
  # To find the credentials: run bin/rails credentials:edit
  http_basic_authenticate_with(
    name: Rails.application.credentials.basic_auth.name,
    password: Rails.application.credentials.basic_auth.password,
  )

  def provision
    @account = Account.create_with(
      plan_slug: params["plan-slug"],
      is_tester: request.headers['X-QN-TESTING'].present?,
    ).find_or_create_by(
      quicknode_id: params["quicknode-id"],
    )

    @endpoint = @account.endpoints.create(
      quicknode_id: params["endpoint-id"],
      http_url: params["http-url"],
      wss_url: params["wss-url"],
      chain: params["chain"],
      network: params["network"],
    )

    render json: {
      status: "success",
      'dashboard-url': dashboard_path(@account),
      'access-url': nil,
    }
  end

  def update; end

  def deactivate_endpoint; end

  def deprovision; end
end
