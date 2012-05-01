# In your code, this LOAD_PATH malarky won't be necessary because the gem will
# already be on your load path. This is just here for my own testing purposes so
# that I can test the examples against the latest code base.
libdir = File.absolute_path(File.dirname(__FILE__)) + '/../lib'
$LOAD_PATH.unshift(libdir) unless $LOAD_PATH.include?(libdir)

require 'vimcolorscheme'

scheme = VimColorScheme.new :scheme_name, :dark do
  comment "author: Sam Rose <samwho@lbak.co.uk>"

  raw "if version < 700"
  raw "  finish"
  raw "endif\n"

  highlight :Normal do
    guifg '#ffffff'
    guibg '#000000'

    ctermfg :none
    ctermbg :none

    gui :bold, :italic
  end
end

scheme.save_to_vim!
