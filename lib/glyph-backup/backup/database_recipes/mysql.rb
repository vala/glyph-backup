module GlyphBackup
  module Backup
    module DatabaseRecipes
      class Mysql
        class << self
          def execute config, dest_path
            command = "mysqldump -u #{ config['username'] } "
            # Add password if needed
            command << "-p#{ config['password'] } " if(config['password'] && config['password'] != "")
            command << "#{ config['database'] } > #{ dest_path }.sql"
            # Execute
            system(command)
          end
        end
      end
    end
  end
end