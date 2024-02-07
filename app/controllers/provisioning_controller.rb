# frozen_string_literal: true

class ProvisioningController < ApplicationController
  skip_before_action :verify_authenticity_token

  # Authenticate with HTTP Basic Auth.
  # To find the credentials: run bin/rails credentials:edit
  http_basic_authenticate_with(
    name: Rails.application.credentials.basic_auth.name,
    password: Rails.application.credentials.basic_auth.password,
  )

  def provision
    @account = Account.create_with(
      plan_slug: params["plan"],
      is_test: request.headers['X-QN-TESTING'].present?,
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

  def update
    @account = Account.find_by(quicknode_id: params["quicknode-id"])
    render_404 and return unless @account

    @endpoint = Endpoint.find_by(quicknode_id: params["endpoint-id"])
    render_404 and return unless @endpoint

    @account.update(
      plan_slug: params["plan"],
    )

    @endpoint.update(
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

  def deactivate_endpoint
    @account = Account.find_by(quicknode_id: params["quicknode-id"])
    render_404 and return unless @account

    @endpoint = Endpoint.find_by(quicknode_id: params["endpoint-id"])
    render_404 and return unless @endpoint

    @endpoint.discard

    render json: {
      status: "success",
    }
  end

  def deprovision
    @account = Account.find_by(quicknode_id: params["quicknode-id"])
    render_404 and return unless @account

    @endpoint = Endpoint.find_by(quicknode_id: params["endpoint-id"])
    render_404 and return unless @endpoint

    @account.endpoints.each(&:discard)
    @account.discard

    render json: {
      status: "success",
    }
  end
end
