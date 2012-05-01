This is a Ruby DSL for creating Vim color schemes. I personally found color
schemes difficult to get working in both terminal and graphical interfaces, this
DSL tries to remedy that by, for example, automatically filling in the value of
guibg by looking at ctermbg.

# Installation

Installation is standard for a Ruby gem:

    gem install vimcolorscheme

# Usage

Let's start by showing you a really small example:

``` ruby
require 'vimcolorscheme'

scheme = VimColorScheme.new :scheme_name, :dark do

end

scheme.save_to_vim!
```

Here we're starting a new vim color scheme with the name of `:scheme_name`
(which will be converted into a string later) and it's going to be a dark theme.

At the end of this script we save the color scheme to our vim directory with the
`save_to_vim!` method on the scheme object. This will write our color scheme to
the file `~/.vim/colors/scheme_name.vim`. The exclamation mark means it will
overwrite if a file with that name exists. You can omit the exclamation mark if
you would rather be prompted.

## Adding highlights

Let's expand this example to actually do something useful: highlight!

``` ruby
require 'vimcolorscheme'

scheme = VimColorScheme.new :scheme_name, :dark do
  highlight :Normal do
    guifg '#ffffff'
    guibg '#000000'
  end
end

scheme.save_to_vim!
```

The `highlight` method takes a name argument, which can be anything with a
`to_s` method and a block, which gives us access to some really cool methods.

There are methods for all of the following attributes: `gui`, `guifg`, `guibg`,
`cterm`, `ctermfg`, and `ctermbg`. Calling them with no arguments will return
their value, which is nil by default, and calling them with arguments will set
their value.

Let's have a look at what that outputs when we save the file as `vimscheme1.rb`
and run it with:

    ruby vimscheme1.rb

And the output is:

``` vim
set background=dark

highlight clear

if exists('syntax_on')
  syntax reset
endif

let g:colors_name = 'scheme_name'

highlight Normal gui=NONE guifg=#ffffff guibg=#000000 cterm=NONE ctermfg=231
ctermbg=16
```

The top part of the file is some obligatory boilerplate stuff such as setting
the background to light or dark, clearing the current highlighting and syntax
and setting the color scheme name inside of vim itself.

The last line is what we're interested in. The highlight line. Notice how it
has values for both the guifg _and_ ctermfg? Internally it works out what the
closest match is for the color and sets it for you.

You don't need to accept this automatic color defaulting if you don't want. To
stop it happening, just explicitly set what you want the ctermfg attribute to
be:

``` ruby
require 'vimcolorscheme'

scheme = VimColorScheme.new :scheme_name, :dark do
  highlight :Normal do
    guifg '#ffffff'
    guibg '#000000'

    ctermfg :none
    ctermbg :none
  end
end

scheme.save_to_vim!
```

### What about bold and underline and stuff?

Setting the gui and cterm elements works slightly differently. These methods
take as many arguments you give them. Let's see an example:

``` ruby
require 'vimcolorscheme'

scheme = VimColorScheme.new :scheme_name, :dark do
  highlight :Normal do
    guifg '#ffffff'
    guibg '#000000'

    ctermfg :none
    ctermbg :none

    gui :bold, :italic
  end
end

scheme.save_to_vim!
```

And the corresponding output:

``` vim
set background=dark

highlight clear

if exists('syntax_on')
  syntax reset
endif

let g:colors_name = 'scheme_name'

highlight Normal gui=bold,italic guifg=#ffffff guibg=#000000 cterm=bold,italic
ctermfg=NONE ctermbg=NONE
```

Notice how both `gui` _and_ `cterm` have been given bold and italic properties?
This should hopefully make color scheme development simpler and more
expressive by harnessing the power of Ruby.

## Comments

If you want to add comments into your resulting color scheme file that's
possible too! Check this out:

``` ruby
require 'vimcolorscheme'

scheme = VimColorScheme.new :scheme_name, :dark do
  comment "author: Sam Rose <samwho@lbak.co.uk>"

  highlight :Normal do
    guifg '#ffffff'
    guibg '#000000'

    ctermfg :none
    ctermbg :none

    gui :bold, :italic
  end
end

scheme.save_to_vim!
```

See that `comment` line near the top? That tells people that I authored this
theme. Let's see what it looks like in the vim file:

``` vim
" author: Sam Rose <samwho@lbak.co.uk>

set background=dark

highlight clear

if exists('syntax_on')
  syntax reset
endif

let g:colors_name = 'scheme_name'

highlight Normal gui=bold,italic guifg=#ffffff guibg=#000000 cterm=bold,italic
ctermfg=NONE ctermbg=NONE
```

We now have a comment at the top! Sweet. The astute among you may be curious
about the placement of the boilerplate code. Why isn't it above the comment?
Comments at the start of a document are treated specially. Before the document
is created, vimcolorscheme looks through what we've done and all comments that
happen before anything else are placed at the very top of the file. In short,
all comments that you create before you create anything else will end up at the
very top of the file.

### Block comments

You can also insert comments using blocks. This following snippet of code is
exactly the same as the last one:

``` ruby
require 'vimcolorscheme'

scheme = VimColorScheme.new :scheme_name, :dark do
  comment do
    "author: Sam Rose <samwho@lbak.co.uk>"
  end

  highlight :Normal do
    guifg '#ffffff'
    guibg '#000000'

    ctermfg :none
    ctermbg :none

    gui :bold, :italic
  end
end

scheme.save_to_vim!
```

## Raw input

This DSL isn't perfect. There are things you can't do. Because of this, the
ability to implement raw strings into the document is present. With this we can
do things such as define vim variable or insert if statements into our color
scheme file. Example:

``` ruby
require 'vimcolorscheme'

scheme = VimColorScheme.new :scheme_name, :dark do
  comment do
    "author: Sam Rose <samwho@lbak.co.uk>"
  end

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
```

Let's see what that gives us:

``` vim
" author: Sam Rose <samwho@lbak.co.uk>

set background=dark

highlight clear

if exists('syntax_on')
  syntax reset
endif

let g:colors_name = 'scheme_name'

if version < 700
  finish
endif

highlight Normal gui=bold,italic guifg=#ffffff guibg=#000000
cterm=bold,italic ctermfg=NONE ctermbg=NONE
```

As expected, the if statement is just pasted in verbatim. It's not pretty, but
it lets us do things the DSL wouldn't let us do "natively".
