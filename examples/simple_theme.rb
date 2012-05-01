# In your code, this LOAD_PATH malarky won't be necessary because the gem will
# already be on your load path. This is just here for my own testing purposes so
# that I can test the examples against the latest code base.
libdir = File.absolute_path(File.dirname(__FILE__)) + '/../lib'
$LOAD_PATH.unshift(libdir) unless $LOAD_PATH.include?(libdir)

require 'vimcolorscheme'

VimColorScheme.new :simple_theme, :dark do
  highlight :Normal do
    ctermfg 231
    ctermbg :none
  end

  comment "Highlighting for a constant in Ruby."
  highlight :rubyConstant do
    guifg '#ff0000'
    gui   :bold
  end
end.save_to_vim!
