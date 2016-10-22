class Changelog
  attr_accessor :version, :date, :body

  class << self
    def all
      logs
    end

    def latest
      @latest ||= logs.first
      @latest
    end

    def summary(n)
      return logs if n.to_i < 1
      logs.take(n)
    end

    private

    def logs
      @logs ||= lambda do
        path = Rails.root.join('config', 'changelogs.yml')
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
  end
end
