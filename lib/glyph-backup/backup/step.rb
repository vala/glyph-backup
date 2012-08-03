require 'fileutils'

module GlyphBackup
  module Backup
    class Step      
      @@role = nil
      
      class << self
        def build config = {}
          type = Backup.const_get "#{ config.delete(:type)].to_s.capitalize }Step"
          conf, dir, env = config[:config], config[:dir], config[:env]
          # Return built step
          type.new conf, dir, env
        end
        
        def role(val)
          @@role = val
        end
      end
      
      def initialize config, dir, env
        @global_config = config
        @working_dir = dir
        @env = env
        @app_name = config['app_name']
      end
      
      def run
        raise "The #run method should be defined in #{ self.class.to_s } !"
      end
      
      def filename
        File.basename(@working_dir)
      end
      
      def config
        @_config ||= @global_config[@@role.to_s]
      end      
      
      def pwd
        FileUtils.pwd
      end
    end
  end
end

require 'glyph-backup/backup/database_step'
require 'glyph-backup/backup/app_step'
require 'glyph-backup/backup/archive_step'
require 'glyph-backup/backup/upload_step'
