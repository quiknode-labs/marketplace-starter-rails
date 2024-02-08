# frozen_string_literal: true

class DashboardController < ApplicationController
  before_action :authenticate_via_jwt!

  def index
    unless @current_account
      logger.info "[401 Unauthorized] #{@error}"
      render_401 and return
    end

    @endpoint = @current_account.endpoints.kept
  end
end
