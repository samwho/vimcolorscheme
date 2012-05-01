require 'spec_helper'
require 'fileutils'

describe VimColorScheme::Base do
  let :test_scheme do
    VimColorScheme.new :test_scheme, :dark do
      comment "This is a comment!"
      comment do
        "This is a block comment!"
      end

      highlight :Normal do
        ctermfg '231'
        ctermbg '31'
        cterm   :bold, :underline
      end

      raw "Some raw input."

      raw do
        "Some raw block input."
      end
    end.to_s
  end

  let :test_scheme_path do
    VimColorScheme::ROOTDIR + '/spec/data/test_scheme.vim'
  end

  let :test_scheme_object do
    VimColorScheme.new :test_scheme, :dark do
      highlight :Normal do
        ctermfg '231'
        ctermbg '31'
        cterm   :bold, :underline
      end
    end
  end

  # Ensure that the test scheme file does not exists for each test.
  after :each do
    FileUtils.rm test_scheme_path if File.exists?(test_scheme_path)
  end

  it "should print out the color scheme name" do
    test_scheme.should include("let g:colors_name = 'test_scheme'")
  end

  it "should set the background" do
    test_scheme.should include("set background=dark")
  end

  it "should clear highlighting at the start" do
    test_scheme.should include("highlight clear")
  end

  it "should check if syntax highlighting is on" do
    test_scheme.should include("if exists('syntax_on')")
  end

  it "should set bold and underline style values" do
    test_scheme.should include("cterm=bold,underline")
  end

  it 'should write to file with the save method' do
    test_scheme_object.save!(test_scheme_path)

    File.open(test_scheme_path) do |file|
      file.read.should == test_scheme_object.to_s
    end
  end

  it 'should render comments' do
    test_scheme.should include('" This is a comment!' + "\n")
  end

  it 'should render block comments' do
    test_scheme.should include('" This is a block comment!' + "\n")
  end

  it 'should render comments at the top... at the top' do
    test_scheme.start_with?('" This is a comment!' + "\n").should be_true
  end

  it 'should render raw' do
    test_scheme.should include("Some raw input.\n")
  end

  it 'should render raw blocks' do
    test_scheme.should include("Some raw block input.\n")
  end
end
