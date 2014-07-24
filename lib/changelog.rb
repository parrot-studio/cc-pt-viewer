class Changelog

  attr_accessor :version, :date, :body

  class << self

    def logs
      @logs ||= lambda do
        path = File.join(Rails.root, 'config', 'changelogs.yml')
        ls = YAML.load(File.read(path))
        ls.map do |l|
          log = self.new
          log.version = l['ver']
          log.date = l['date']
          log.body = l['body']
          log
        end
      end.call
      @logs
    end

    def latest
      @latest ||= logs.first
      @latest
    end

  end

end