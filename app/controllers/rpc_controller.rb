# frozen_string_literal: true

class RPCController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :validate_headers

  def rpc # rubocop:disable Metrics/CyclomaticComplexity, Metrics/AbcSize
    render_404 and return unless params[:method].present?

    @account = Account.kept.find_by(quicknode_id: request.headers["X-QUICKNODE-ID"])
    render_404 and return unless @account.present?

    @endpoint = @account.endpoints.kept.find_by(quicknode_id: request.headers["X-INSTANCE-ID"])
    render_404 and return unless @endpoint.present?

    begin
      class_name = params[:method].split('_').map(&:camelize).join
      handler_name = "RPCMethodHandlers::#{class_name}"
      logger.info "[RPC] #{params[:method]} => #{handler_name}"
      handler = handler_name.constantize
      result = handler.new(params[:params], @endpoint).call
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
