require 'yaml'
require 'fileutils'

require 'glyph-backup/backup/step'

module GlyphBackup
  module Backup
    def backup!
      # Load YAML config file
      load_config!
      # Load steps
      define_steps!
      
      prepare!
      begin
        # Run steps !
        @steps.each(&:run)
      ensure
        # Be sure to clean temp files
        clean!
      end
    end
    
    def load_config!
      # Load and store backup YAML config file
      @config = YAML.load File.read @options[:config_path]
    end
    
    def define_steps!
      # Build each steps if they're meant to be executed
      @steps = [:database, :app, :archive, :upload].map do |step|
        Step.build(type: step, config: @config, dir: @tmp_dir, env: @options[:env]) if @options[:execute][step]
      end
    end
    
    def prepare!
      # Set and create temp folder
      @tmp_dir = "/tmp/#{ @config['app_name'] }-backup-#{ Time.now.strftime('%Y_%m_%d-%H_%M_%S_%L') }"
      FileUtils.mkdir_p @tmp_dir
    end
    
    def clean!
      # Delete tmp folder
      FileUtils.rm_r @tmp_dir
    end
  end
end
