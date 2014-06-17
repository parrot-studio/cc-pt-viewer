class ViewerController < ApplicationController

  def index
  end

  def datas
    render json: Arcana.all.map(&:sirialize)
  end

end
