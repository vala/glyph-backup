module GlyphBackup
  module Backup
    class AppStep < Step
      role :app
      
      def initialize *args
        super *args
        @folders = config['folders']
      end
      
      def run
        @folders.each do |folder|
          FileUtls.cp File.join(pwd, folder) File.join(@working_dir, folder)
        end
      end      
    end
  end
end
