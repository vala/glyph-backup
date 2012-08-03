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
        @address = @config['address']
        @port = @config['port']
        @username = @config['username']
        @password = @config['password']        
      end
      
      def run
        t = Time.now
        day, hour = t.strftime('%Y_%m_%d'), t.strftime('%H_%M')
        Net::FTP.open(@address, @username, @password) do |ftp|
          # Navigate to path : '/backups/app_name/day/hour' directory and 
          # create directories if the don't exist
          ['backups', @app_name, day, hour].each do |dir|
            mkdir_p(ftp, dir) && ftp.chdir(dir)
          end
          
          ftp.putbinaryfile(File.join(@working_dir, "#{ filename }.tar.gz"))
        end
      end
      
      def mkdir_p ftp, dir
        ftp.mkdir(dir) unless ftp.list.length > 0 && ftp.nlst.include?(dir)
      end
    end
  end
end