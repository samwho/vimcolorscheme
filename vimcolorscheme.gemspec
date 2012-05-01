Gem::Specification.new do |s|
  s.name = %q{vimcolorscheme}
  s.version = "0.1"
  s.date = %q{2012-05-01}
  s.authors = ["Sam Rose"]
  s.email = %q{samwho@lbak.co.uk}
  s.summary = %q{A Ruby DSL for creating Vim color schemes}
  s.homepage = %q{http://github.com/samwho/vimcolorscheme}
  s.description = %q{Allows for creating of Vim color schemes using a nifty Ruby DSL}
  s.required_ruby_version = '>= 1.8.7'
  s.license = 'MIT'

  # Add all files to the files parameter.
  s.files = []
  Dir["**/*.*"].each { |path| s.files.push path }
end
