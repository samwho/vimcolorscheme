require 'spec_helper'

describe VimColorScheme::HighlightNode do
  let :guinode do
    temp = VimColorScheme::HighlightNode.new :Normal
    temp.guifg '#ffffff'
    temp.guibg '#000000'
    temp.to_s
  end

  let :ctermnode do
    temp = VimColorScheme::HighlightNode.new :Normal
    temp.ctermfg '34'
    temp.ctermbg '35'
    temp.to_s
  end

  let :bothnode do
    temp = VimColorScheme::HighlightNode.new :Normal
    temp.ctermfg '34'
    temp.ctermbg '35'
    temp.guifg '#ffffff'
    temp.guibg '#000000'
    temp.to_s
  end

  let :reversenode do
    temp = VimColorScheme::HighlightNode.new :Normal
    temp.gui :reverse
    temp.to_s
  end

  it 'should start with the word highlight' do
    guinode.start_with?('highlight').should be_true
    bothnode.start_with?('highlight').should be_true
    ctermnode.start_with?('highlight').should be_true
    reversenode.start_with?('highlight').should be_true
  end

  it "should convert between gui and cterm colors correctly" do
    guinode.should include('ctermfg=231')
    guinode.should include('ctermbg=16')
  end

  it "should convert between cterm and gui colors correctly" do
    ctermnode.should include('guifg=#00af00')
    ctermnode.should include('guibg=#00af5f')
  end

  it 'should not convert colors if both are present' do
    bothnode.should include('ctermfg=34')
    bothnode.should include('ctermbg=35')
    bothnode.should include('guifg=#ffffff')
    bothnode.should include('guibg=#000000')
  end

  it 'should correctly default nodes to none if no value is given' do
    bothnode.should include('gui=NONE')
  end

  it 'should correctly conver :reverse values to REVERSE' do
    reversenode.should include('gui=REVERSE')
  end
end
