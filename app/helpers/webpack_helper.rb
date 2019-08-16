# manifest.jsonから実体を取り出すhelper
#
# developmentではwebpack-dev-serverから取得
#   from: webpack-dev-server --mode=development --hot --port=3035 --contentBase=./public
# productionではpublic/packsから取得
#
# see: https://inside.pixiv.blog/subal/4615
# see: https://numb86-tech.hatenablog.com/entry/2019/01/10/211416
module WebpackHelper
  def asset_pack_path(entry, **options)
    raise "assets not found => #{entry}" unless manifest.key?(entry)

    target = manifest.fetch(entry)

    asset_path("#{asset_host}/#{target}", **options)
  end

  def javascript_pack_tag(entry, **options)
    path = asset_pack_path("#{entry}.js")

    options = {
      src: path,
      defer: true
    }.merge(options)

    options.delete(:defer) if options[:async]

    javascript_include_tag '', **options
  end

  def stylesheet_pack_tag(entry, **options)
    path = asset_pack_path("#{entry}.css")

    options = {
      href: path
    }.merge(options)

    stylesheet_link_tag '', **options
  end

  private

  def asset_host
    Rails.env.production? ? '' : webpack_server
  end

  # rubocop:disable Rails/HelperInstanceVariable
  def manifest
    @manifest ||= lambda do
      json = Rails.env.production? ? manifest_for_production : manifest_for_development
      begin
        Oj.load(json)
      rescue
        {}
      end
    end.call
    @manifest
  end
  # rubocop:enable Rails/HelperInstanceVariable

  def manifest_for_production
    file = Rails.root.join('public', 'packs', 'manifest.json')
    raise 'manifest not found' unless File.exist?(file)

    File.read(file)
  end

  def manifest_for_development
    require 'open-uri'
    OpenURI.open_uri("#{webpack_server}/packs/manifest.json").read
  end

  def webpack_server
    "http://#{request.host}:3035"
  end
end
