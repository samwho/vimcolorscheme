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

    # Creates a comment node in the document. It takes a single argument, which
    # is the string that will be in the comment. You don't need to include the "
    # comment character in the string, that will be done for you when the vim
    # color scheme document is created.
    #
    # Example:
    #
    #   comment "This is a comment!"
    #
    # Alternately, you can create a comment by returning a string from a block:
    #
    #   comment do
    #     "This is a comment!"
    #   end
    #
    # Both examples above yield the same result.
    def comment string = nil
      if block_given?
        @nodes << CommentNode.new(yield)
      else
        @nodes << CommentNode.new(string)
      end
    end

    # Creates a raw node in the current document. Raw nodes are inteded for
    # users that want to insert code into their vim color scheme that we don't
    # currently have a native implementation for.
    #
    # Example:
    #
    #   raw "let g:my_var = 'variable!'"
    #
    # You can also give raw a block that returns a string:
    #
    #   raw do
    #     "let g:my_var = 'variable!'"
    #   end
    #
    # The two examples above are functionally the same. The strings that are
    # passed to raw will be printed as-is into the vim color scheme file.
    def raw string = nil
      if block_given?
        @nodes << RawNode.new(yield)
      else
        @nodes << RawNode.new(string)
      end
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

      # If the document starts with comments, we want to print those at the top.
      top_comments = @nodes.take_while { |node| node.is_a? CommentNode }
      top_comments.each do |comment|
        result += comment.to_s
      end

      # Vanity new lines ftw.
      result += "\n"

      # Pop the top comments off the node list.
      top_comments.length.times do
        @nodes.shift
      end

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
