# frozen_string_literal: true

class RPCController < ApplicationController
  before_action :validate_headers

  RPC_METHODS = %w[qn_hello_world].freeze

  def rpc
    @account = Account.kept.find_by(quicknode_id: request.headers["X-QUICKNODE-ID"])
    render_404 and return unless @account.present?

    render_404 and return unless RPC_METHODS.include?(params[:method])

    render json: { jsonrpc: "2.0", result: "hello world" }
  end

  private

  def validate_headers # rubocop:disable Metrics/CyclomaticComplexity
    render_400 and return unless request.headers["X-QUICKNODE-ID"].present?
    render_400 and return unless request.headers["X-INSTANCE-ID"].present?
    render_400 and return unless request.headers["X-QN-CHAIN"].present?
    render_400 and return unless request.headers["X-QN-NETWORK"].present?
  end
end
