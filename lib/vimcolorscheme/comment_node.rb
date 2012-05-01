module VimColorScheme
  class CommentNode
    # Initializes the comment node with a comment string.
    def initialize comment
      @comment = comment
    end

    # Renders the comment node by splitting the string at newlines and then
    # appending the " comment character at the start of each line and joining
    # the result with newlines.
    def to_s
      @comment.split(/\n/).map { |str| str = '" ' + str }.join("\n") + "\n"
    end
  end
end
