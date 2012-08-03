require 'net/ftp'

module GlyphBackup
  module Backup
    class UploadStep < Step
      role :remote
      
      def initialize *args
        super *args
        load_credentials!
      end
      
      def load_credentials!
        @address = params['address']
        @port = params['port']
        @username = params['username']
        @password = params['password']        
      end
      
      def run
        log "Uploading archive to #{ @username }@#{ @address } ..."
        t = Time.now
        day, hour = t.strftime('%Y_%m_%d'), t.strftime('%H_%M')
        Net::FTP.open(@address, @username, @password) do |ftp|
          # Navigate to path : '/backups/app_name/day/hour' directory and 
          # create directories if the don't exist
          ['backups', @app_name, day, hour].each do |dir|
            mkdir_p(ftp, dir)
            ftp.chdir(dir)
          end
          
          log "Uploading file : #{ File.join(@working_dir, "#{ filename }.tar.gz") }"
          ftp.putbinaryfile("#{ @working_dir }.tar.gz")
        end
      end
      
      def mkdir_p ftp, dir
        ftp.mkdir(dir) unless ftp.list.length > 0 && ftp.nlst.include?(dir)
      end
    end
  end
end