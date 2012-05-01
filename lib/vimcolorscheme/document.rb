module VimColorScheme
  class Document
    # Creates a new color scheme document. The user will never call this method
    # themselves but an object of this class is what they will be working with
    # through the DSL.
    #
    # This constructor takes the name of the color scheme, whether it is light
    # or dark and an optional option hash as arguments.
    def initialize name, lightordark, options = {}
      @name        = name
      @lightordark = lightordark
      @options     = options
      @nodes       = []
    end

    # Creates a highlight node in the document. You need to give this method
    # call a name and a clock. Here's a usage example:
    #
    #   highlight :Normal do
    #     cterm :bold, :underline
    #   end
    def highlight name, &block
      @nodes << HighlightNode.new(name)
      @nodes.last.instance_eval(&block)
    end

    # Saves this color scheme to a file. If the file exists, the user will be
    # prompted as to whether or not they want to overwrite the file.
    def save path
      if File.exists?(path)
        puts "#{path} already exists! Overwrite? y/n"
        answer = gets
        unless answer == 'n' or answer == 'N'
          File.open(path, 'w') do |file|
            file.write(to_s)
          end
        end
      end
    end

    # Does exactly the same as the save method excpet it doesn't prompt the user
    # if the file exists, it just goes ahead and overwrites it.
    def save! path
      File.open(path, 'w') do |file|
        file.write(to_s)
      end
    end

    # This method will save the color scheme into the user's ~/.vim/colors
    # directory. If the scheme already exists, the user will be prompted asking
    # if they want to overwrite it.
    def save_to_vim
      save(File.expand_path("~/.vim/colors/#{@name.to_s}.vim"))
    end

    # This method does exactly the same as the save_to_vim method but it will
    # not ask if you want to overwrite a file if it exists already, it will just
    # overwrite it.
    def save_to_vim!
      save!(File.expand_path("~/.vim/colors/#{@name.to_s}.vim"))
    end

    # This method converts the object into a valid vim color scheme document. It
    # is what is used to create the color schemes at the end of the DSL block.
    def to_s
      result  = ''

      if @lightordark == :dark
        result += "set background=dark\n\n"
      else
        result += "set background=light\n\n"
      end

      result += "highlight clear\n\n"
      result += "if exists('syntax_on')\n"
      result += "  syntax reset\n"
      result += "endif\n\n"
      result += "let g:colors_name = '#{@name.to_s}'\n\n"

      @nodes.each do |node|
        result += node.to_s
      end

      return result
    end
  end
end
