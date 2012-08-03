$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "glyph-backup/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "glyph-backup"
  s.version     = GlyphBackup::VERSION
  s.authors     = ["Ballestrino Valentin"]
  s.email       = ["vala@glyph.fr"]
  s.homepage    = "http://glyph.fr"
  s.summary     = "Permits to backup your apps, especially Rails ones"
  s.description = "Permits to backup your apps, especially Rails ones"

  s.files         = `git ls-files`.split("\n")
  s.bindir        = "bin"
  s.executables   = 'glbackup'
  s.require_paths = ["lib"]
end
