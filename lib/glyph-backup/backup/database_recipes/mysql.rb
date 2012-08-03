module GlyphBackup
  module Backup
    module DatabaseRecipes
      class Mysql
        class << self
          def execute config, dest_path
            `mysqldump -u #{ config['username'] } -p#{ config['password'] } #{ config['database'] } > #{ dest_path }.sql`
          end
        end
      end
    end
  end
end