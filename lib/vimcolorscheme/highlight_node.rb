module VimColorScheme
  class HighlightNode
    def initialize name, options = {}
      @name    = name
      @options = options

      # Default things to none if they are nil or false.
      gui     :none unless gui
      guifg   :none unless guifg
      guibg   :none unless guibg
      cterm   :none unless cterm
      ctermfg :none unless ctermfg
      ctermbg :none unless ctermbg
    end

    # Processes the values of a node. Basically, if there are values that have
    # not been set, we try to guess them. So we convert gui colors to cterm
    # colors if the cterm colors are not present and default to :none if that
    # isn't possible and so on.
    #
    # This gets called in the to_s method so there's no need to call it
    # explicitly.
    def process
      # Process colors. Set cterm if none, gui if none, based on their
      # counterparts.
      if guifg == :none and ctermfg != :none
        guifg Hex2Term.convert(ctermfg)
      end

      if guibg == :none and ctermbg != :none
        guibg Hex2Term.convert(ctermbg)
      end

      if ctermfg == :none and guifg != :none
        ctermfg Hex2Term.convert(guifg)
      end

      if ctermbg == :none and guibg != :none
        ctermbg Hex2Term.convert(guibg)
      end
    end

    # Converts the Node to a valid entry in a vim color scheme file.
    def to_s
      # Make sure the node has been processed before converting to string.
      process

      result  = "highlight #{@name.to_s} "
      result += "gui=#{attr_to_s(gui)} "
      result += "guifg=#{attr_to_s(guifg)} "
      result += "guibg=#{attr_to_s(guibg)} "
      result += "cterm=#{attr_to_s(cterm)} "
      result += "ctermfg=#{attr_to_s(ctermfg)} "
      result += "ctermbg=#{attr_to_s(ctermbg)}\n"
    end

    # Converts an attribute to string. This accounts for cases such as :none and
    # :reverse and returns the appropriate string.
    def attr_to_s attribute
      case attribute
      when Array
        attribute.map { |a| attr_to_s(a) }.join(',')
      when :none
        'NONE'
      when :reverse
        'REVERSE'
      else
        attribute
      end
    end

    #
    # The following are just default accessors for the various members of the
    # options hash on this object.
    #
    def gui *args
      @options[:gui] = args if args.length > 0
      @options[:gui]
    end

    def guibg new_guibg = nil
      @options[:guibg] = new_guibg if new_guibg
      @options[:guibg]
    end

    def guifg new_guifg = nil
      @options[:guifg] = new_guifg if new_guifg
      @options[:guifg]
    end

    def cterm *args
      @options[:cterm] = args if args.length > 0
      @options[:cterm]
    end

    def ctermbg new_ctermbg = nil
      @options[:ctermbg] = new_ctermbg if new_ctermbg
      @options[:ctermbg]
    end

    def ctermfg new_ctermfg = nil
      @options[:ctermfg] = new_ctermfg if new_ctermfg
      @options[:ctermfg]
    end
  end
end
