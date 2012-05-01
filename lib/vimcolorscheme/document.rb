module VimColorScheme
  class Document
    def initialize options = {}
      @options = options
      @nodes   = []
    end

    def add_node name = nil
      @nodes << Node.new(name)
      return @nodes.last
    end

    def to_s
      result  = ''
      result += @nodes.to_s
    end
  end
end
