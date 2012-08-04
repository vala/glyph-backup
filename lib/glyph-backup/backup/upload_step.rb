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
          
          filepath = "#{ @working_dir }.tar.gz"
          size, progress = File.size(filepath), 0
          
          
          ftp.putbinaryfile(filepath, File.basename(filepath), 1024) do |data|
            progress += data.size
            print "Uploading archive --- Progress : #{ ((progress.to_f / size) * 100).to_i }% (#{ humanize(progress) } / #{ humanize(size) })        \r"
          end
          print "Archive upload complete !"
        end
      end
      
      def mkdir_p ftp, dir
        ftp.mkdir(dir) unless ftp.list.length > 0 && ftp.nlst.include?(dir)
      end
      
      def humanize val
        if val > 1024**3
          "#{ ((val.to_f / 1024**3) * 1000).round.to_f / 1000 }Go"
        elsif val.to_f > 1024**2
          "#{ ((val.to_f / 1024**2) * 1000).round.to_f / 1000 }Mo"
        elsif val > 1024
          "#{ ((val.to_f / 1024) * 1000).round.to_f / 1000 }Ko"
        else
          "#{ val }o"
        end
      end
    end
  end
end