# frozen_string_literal: true

class DashboardController < ApplicationController
  before_action :validate_presence_of_jwt_token!
  before_action :authenticate_via_jwt!

  def index
    unless @current_acccount
      logger.info "[401 Unauthorized] #{@error}"
      render_401 and return
    end

    @endpoint = @current_acccount.endpoints.kept
  end
end
