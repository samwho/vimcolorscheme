module VimColorScheme
  module Base
    def new name, lightordark, &block
      @document = VimColorScheme::Document.new(name, lightordark)
      @document.instance_eval(&block)
      @document
    end
  end

  extend Base
end
