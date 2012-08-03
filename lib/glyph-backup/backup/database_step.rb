module GlyphBackup
  module Backup
    class DatabaseStep < Step
      role :database
      
      def initialize *args
        super *args
        load_credentials!
        # Store dump path without extension
        @dump_path = File.join(@working_dir, filename)
      end
      
      def load_credentials!
        @credentials = (YAML.load File.read config['credentials'])[@env]
      end
      
      def run
        DatabaseRecipes.const_get(config['type'].capitalize).execute(@credentials, @dump_path)
      end
    end
  end
end