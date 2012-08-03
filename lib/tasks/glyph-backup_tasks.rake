namespace :glbackup do
  namespace :make do
    desc "Builds gem and installs it"
    task :install do
      puts "Building gem ..."
      gem_file = `gem build glyph-backup.gemspec`.split("\n").reduce("") { |str, row| (m = row.match(/File:\s*(.+?\.gem)/)) ? (str << m[1]) : str }
      puts `gem install #{ gem_file }`.split("\n")
      `rm #{ gem_file }`
    end
  end
end
