require 'spec_helper'

describe VimColorScheme::Base do
  let :test_scheme do
    VimColorScheme.new :test_scheme, :dark do
      highlight :Normal do
        ctermfg '231'
        ctermbg '31'
      end
    end.to_s
  end

  it "should correct print out the color scheme name" do
    test_scheme.should include("let colors_name = 'test_scheme'")
  end

  it "should correctly set the background" do
    test_scheme.should include("set background=dark")
  end

  it "should correctly clear highlighting at the start" do
    test_scheme.should include("highlight clear")
  end

  it "should check if syntax highlighting is on" do
    test_scheme.should include("if exists('syntax_on')")
  end
end
