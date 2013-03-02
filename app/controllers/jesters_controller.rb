class JestersController < ApplicationController
  respond_to :json
  require_login

  def index
    respond_with Jester.all
  end

  def show
    begin
      respond_with jester
    rescue MongoMapper::DocumentNotFound
      head :not_found
    end
  end

protected
  def jester
    @jester ||= Jester.find_by_slug! params[:id]
  end

end