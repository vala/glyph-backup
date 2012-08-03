require 'optparse'

require 'glyph-backup/backup'

module GlyphBackup
  class CLI    
    include Backup
    
    class << self
      def execute
        self.new parse_options!(ARGV)
      end
    
      def parse_options! args
        options = {
          database: true,
          app: true,
          archive: true,
          upload: true,
          env: 'production'
        }
        
        @parser = OptionParser.new do |opts|
          opts.banner = "Usage: #{ File.basename($0) } [options]"
          
          opts.on '-c', '--config=CONFIG_PATH', 'Sets the config file path' do |value|
            options[:config_path] = value
          end
          
          opts.on '-e', '--env=ENVIRONMENT', 'Sets RAILS_ENV to user, defaults to "production"' do |value|
            options[:env] = value
          end
        end
        
        @parser.parse!(args)
        options
      end
    end
    
    def initialize opts
      @options = opts
      $stdout.sync = true
            
      # Send action
      backup!
    end
    
  end
end