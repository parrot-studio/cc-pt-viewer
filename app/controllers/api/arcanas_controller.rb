class Api::ArcanasController < ApplicationController
  include SearchArcanas

  def search
    as = search_arcanas(query_params)
    render json: (as || {})
  end

  def ptm
    ret = search_members(params[:ptm])
    render json: (ret || {})
  end

  def codes
    as = specified_arcanas(params[:codes])
    render json: (as || [])
  end

  def name_search
    as = search_from_name(params[:name])
    render json: (as || [])
  end

  def request_mail
    if ServerSettings.use_mail?
      mail = AdminMailer.request_mail(params[:text], ip: request.remote_ip)
      mail.deliver_later if mail
    end
    head :no_content
  end
end
