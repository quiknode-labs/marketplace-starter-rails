# frozen_string_literal: true

class ApplicationController < ActionController::Base
  def render_404
    respond_to do |format|
      format.html { render file: "#{Rails.root}/public/404.html", status: :not_found }
      format.json { render json: json_rpc_error(404, "Not Found"), status: :not_found }
    end
  end

  def render_400
    respond_to do |format|
      format.html { render file: "#{Rails.root}/public/400.html", status: :bad_request }
      format.json { render json: json_rpc_error(400, "Bad Request"), status: :bad_request }
    end
  end

  def render_401
    respond_to do |format|
      format.html { render file: "#{Rails.root}/public/401.html", status: :unauthorized }
      format.json { render json: json_rpc_error(401, "Unauthorized"), status: :unauthorized }
    end
  end

  def validate_presence_of_jwt_token!
    render_400 and return unless params['jwt'].present?
  end

  def authenticate_via_jwt! # rubocop:disable Metrics/AbcSize
    if session[:account_quicknode_id].present?
      @current_acccount = Account.kept.find_by(quicknode_id: session[:account_quicknode_id])
    else
      token = params['jwt']
      begin
        decoded_tokens = JWT.decode token, Rails.application.credentials.jwt.secret, true
        @decoded_token = decoded_tokens.first
        logger.info "[DASH] decoded_token: #{@decoded_token}"
        session[:account_quicknode_id] = @decoded_token["quicknode_id"]
        session[:email] = @decoded_token["email"]
        session[:name] = @decoded_token["name"]
        session[:organization_name] = @decoded_token["organization_name"]
      rescue JWT::VerificationError, JWT::DecodeError => e
        logger.error "[BAD JWT] #{e.message}"
        @error = 'forged or missing JWT'
      end
      return if @error.present?

      @current_acccount = Account.kept.find_by(quicknode_id: session[:account_quicknode_id])
      @error = "account not provisioned" unless @current_acccount
    end
  end

  private

  def json_rpc_error(code, message)
    {
      id: 1,
      error: {
        code:,
        message:,
      },
      jsonrpc: "2.0",
    }
  end
end
