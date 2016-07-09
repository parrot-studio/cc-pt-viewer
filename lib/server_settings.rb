class ServerSettings

  PT_VERSION = lambda{ Settings.api.pt_version }.call
  RECENTLY_SIZE = lambda do
    size = Settings.api.recently.to_i
    size > 0 ? size : 24
  end.call
  USE_MAIL = lambda{ Settings.mail.use ? true : false }.call

  class << self

    def data_version
      unless @data_version
        update_data_version! unless File.exist?(version_file)
        @data_version = File.read(version_file).chomp
      end
      @data_version
    end

    def update_data_version!(ver = nil)
      ver ||= format_time(Time.current)
      File.open(version_file, 'w') { |f| f.puts(ver) }
      @data_version = ver
    end

    def data_update_time
      return Time.current unless Rails.env.production?
      @data_update_time ||= Time.parse(data_version)
      @data_update_time
    end

    def pt_version
      PT_VERSION
    end

    def recently
      RECENTLY_SIZE
    end

    def use_mail?
      USE_MAIL
    end

    def mail_from
      Settings.mail.from
    end

    def mail_admin_to
      Settings.mail.admin.to
    end

    private

    def version_file
      Rails.root.join('tmp', 'data_version')
    end

    def format_time(t)
      t.strftime('%Y%m%d%H%M%S')
    end

  end

end
