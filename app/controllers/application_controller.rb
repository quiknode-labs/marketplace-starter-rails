# frozen_string_literal: true

class ApplicationController < ActionController::Base
  def render_404
    respond_to do |format|
      format.html { render file: "#{Rails.root}/public/404.html", status: :not_found }
      format.json { render json: { error: "Not found" }, status: :not_found }
    end
  end
end
