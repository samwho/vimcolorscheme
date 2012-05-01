module VimColorScheme
  class Document
    def initialize name, lightordark, options = {}
      @name        = name
      @lightordark = lightordark
      @options     = options
      @nodes       = []
    end

    def highlight name, &block
      @nodes << HighlightNode.new(name)
      @nodes.last.instance_eval(&block)
    end

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
      result += "let colors_name = '#{@name.to_s}'\n\n"

      @nodes.each do |node|
        result += node.to_s
      end

      return result
    end
  end
end
