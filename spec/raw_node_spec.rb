require 'spec_helper'

describe VimColorScheme::RawNode do
  let :raw_node do
    raw = VimColorScheme::RawNode.new "Raw content."
    raw.to_s
  end

  it 'should render content verbatim' do
    raw_node.should == "Raw content.\n"
  end
end
