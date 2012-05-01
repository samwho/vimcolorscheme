module VimColorScheme
  class RawNode
    # The raw node gets initialized with a string. This string will later just
    # be printed as-is into the vim file.
    def initialize raw
      @raw = raw
    end

    # Just returns the value that was passed into the constructor of this
    # object.
    def to_s
      @raw + "\n"
    end
  end
end
