libdir = File.dirname(__FILE__)
$LOAD_PATH.unshift(libdir) unless $LOAD_PATH.include?(libdir)

module VimColorScheme
  ROOTDIR = File.expand_path(File.dirname(__FILE__) + '/..')
end

require 'vimcolorscheme/hex2term'
require 'vimcolorscheme/highlight_node'
require 'vimcolorscheme/comment_node'
require 'vimcolorscheme/raw_node'
require 'vimcolorscheme/document'
require 'vimcolorscheme/base'
