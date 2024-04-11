require 'logger'

class Log
    attr_accessor :logger
    @logger = Logger.new(STDOUT)
    @logger.datetime_format = '%Y-%m-%d %H:%M:%S'

    def self.info(message)
        @logger.info(message)
    end

    def self.warn(message)
        @logger.warn(message)
    end
end