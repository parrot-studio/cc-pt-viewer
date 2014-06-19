class ViewerController < ApplicationController

  def index
    @arcanas = {}
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
    code = params[:code]
    (redirect_to root_path; return) if code.blank?
    @arcanas = parse_pt_code(code)
    (redirect_to root_path; return) unless @arcanas
    render :index
  end

  private

  def parse_pt_code(code)
    part = "([FKPMA]\\d+|N)"
    parser = /\A(V\d+)#{part * 6}\z/
    m = code.upcase.match(parser)
    return unless m

    selector = lambda {|c| c == 'N' ? nil : c}
    {
      mem1: selector.call(m[2]),
      mem2: selector.call(m[3]),
      mem3: selector.call(m[4]),
      mem4: selector.call(m[5]),
      sub1: selector.call(m[6]),
      sub2: selector.call(m[7]),
    }
  end

end
