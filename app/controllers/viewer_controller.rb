class ViewerController < ApplicationController

  def index
  end

  def datas
    cache_name = 'arcanas'
    as = Rails.cache.read(cache_name)
    if as.blank?
      as = Arcana.order('job_type, rarity DESC, job_index DESC')
      Rails.cache.write(cache_name, as)
    end
    render json: as
  end

  def pt
    render :index
  end

end
