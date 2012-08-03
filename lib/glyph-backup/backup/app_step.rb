module GlyphBackup
  module Backup
    class AppStep < Step
      role :app
      
      def initialize *args
        super *args
        @folders = params['folders']
      end
      
      def run
        @folders.each do |folder|
          # Store src and dest paths
          src, dest = File.join(pwd, folder), File.join(@working_dir, folder)
          log "Moving file : #{ src } - to : #{ dest }"
          # Copy file
          File.directory?(src) ? FileUtils.cp_r(src, dest) : FileUtils.cp(src, dest)
        end
      end      
    end
  end
end
