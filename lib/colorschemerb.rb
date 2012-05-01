libdir = File.dirname(__FILE__)
$LOAD_PATH.unshift(libdir) unless $LOAD_PATH.include?(libdir)

module ColorSchemeRb
  ROOTDIR = File.expand_path(File.dirname(__FILE__) + '/..')
end

require 'colorschemerb/hex2term'
