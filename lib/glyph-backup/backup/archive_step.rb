module GlyphBackup
  module Backup
    class ArchiveStep < Step
      role :archive
      
      def run
        log "Archiving file : #{ filename }"
        `cd /tmp && tar czvf #{ filename }.tar.gz #{ filename }`
      end
    end
  end
end
