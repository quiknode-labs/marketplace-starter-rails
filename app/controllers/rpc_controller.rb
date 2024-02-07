# frozen_string_literal: true

class RPCController < ApplicationController
  before_action :validate_headers

  def rpc
    @account = Account.kept.find_by(quicknode_id: request.headers["X-QUICKNODE-ID"])
    render_404 and return unless @account.present?
    render_404 and return unless params[:method].present?

    begin
      handler = "RPCMethodHandlers::#{params[:method].camelize}".constantize
      result = handler.new(params).call
      render json: result
    rescue NameError
      render_404 and return
    end
  end

  private

  def validate_headers # rubocop:disable Metrics/CyclomaticComplexity
    render_400 and return unless request.headers["X-QUICKNODE-ID"].present?
    render_400 and return unless request.headers["X-INSTANCE-ID"].present?
    render_400 and return unless request.headers["X-QN-CHAIN"].present?
    render_400 and return unless request.headers["X-QN-NETWORK"].present?
  end
end
