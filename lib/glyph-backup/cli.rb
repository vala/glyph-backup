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
          config_path: nil,
          database: true,
          app: true,
          archive: true,
          upload: true,
          env: 'production',
          only_config: false,
          only_help: false
        }
        
        @parser = OptionParser.new do |opts|
          opts.banner = "Usage: #{ File.basename($0) } [-c path] [-g path] [-e environment]"
          
          opts.on '-c', '--config=path', 'Sets the config file path' do |value|
            options[:config_path] = value
          end
          
          opts.on '-e', '--env=environment', 'Sets RAILS_ENV to user, defaults to "production"' do |value|
            options[:env] = value
          end
          
          opts.on '-g', '--generate-to=path', 'Only generate a default config file at the wanted path' do |value|
            options[:only_config] = true
            options[:config_path] = value
          end
          
          opts.on '-h', '--help', 'Shows this help' do
            options[:only_help] = true
          end
        end
        
        @parser.parse!(args)
        options
      end
    end
    
    def initialize opts
      @options = opts
      $stdout.sync = true
      
      # Show help
      if @options[:only_help]
        warn self.class.instance_variable_get('@parser')
        exit
      # Missing config path
      elsif @options[:config_path]
        warn "Config file path not given, please specify one with the corresponding option"
        puts "------------------------------------------------------------------------------"
        warn self.class.instance_variable_get('@parser')
        exit
      # Generate config file
      elsif @options[:only_config]
        generate_config!
      # Backup
      else
        backup!
      end
    end
    
    def generate_config!
      # Ask for overwriting file if existing yet
      if File.exists? @options[:config_path]
        print "Config file location (#{ @options[:config_path] }) already exist, do you want to overwrite it ? [Y/n] "
        unless gets.match(/^y$/i)
          warn "Aborted ..."
          exit
        end
      end
      
      # Config file template
      config = <<-CONFIG
        ---
        # Application name, for backup folder name
        app_name: 

        # Database configuration
        db:
          type: mysql
          credentials: config/database.yml

        # Application backup params
        app:
          folders:
            - public/system

        # Remote server configuration
        remote:
          type: ftp
          address: localhost
          port: 21
          username: root
          password:
          
      CONFIG
      
      # Generate config file
      File.open(@options[:config_path], 'w') do |f|
        f.puts config.gsub(/^        /, '')
      end
      
      puts "Config file generated !"
    end
    
  end
end