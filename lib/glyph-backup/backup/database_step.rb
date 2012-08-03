module GlyphBackup
  module Backup
    class DatabaseStep < Step
      role :db
      
      def initialize *args
        super *args
        load_credentials!
        # Store dump path without extension
        @dump_path = File.join(@working_dir, filename)
      end
      
      def load_credentials!
        @credentials = (YAML.load File.read params['credentials'])[@env]
      end
      
      def run
        log "Dumping database to #{ @dump_path }"
        DatabaseRecipes.const_get(params['type'].capitalize).execute(@credentials, @dump_path)
      end
    end
  end
end

require 'glyph-backup/backup/database_recipes'