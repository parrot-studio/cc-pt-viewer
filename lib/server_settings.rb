class ServerSettings

  class << self

    def data_version
      unless @data_version
        update_data_version! unless File.exist?(version_file)
        @data_version = File.read(version_file).chomp
      end
      @data_version
    end

    def update_data_version!(ver = nil)
      ver ||= format_time(Time.zone.now)
      File.open(version_file, 'w') { |f| f.puts(ver) }
      @data_version = ver
    end

    def data_update_time
      return Time.zone.now unless use_cache?
      @data_update_time ||= Time.parse(data_version)
      @data_update_time
    end

    def pt_version
      config[:pt_version]
    end

    def recently
      (config[:recently] || 24).to_i
    end

    def use_mail?
      config[:mail] ? true : false
    end

    def use_cache?
      config[:cache] ? true : false
    end

    def mail_from
      mail_config[:from]
    end

    def mail_admin_to
      mail_config[:admin][:to]
    end

    private

    def config
      Rails.application.config.x.settings
    end

    def mail_config
      Rails.application.config.x.mail
    end

    def version_file
      Rails.root.join('tmp', 'data_version')
    end

    def format_time(t)
      t.strftime('%Y%m%d%H%M%S')
    end

  end

end
