require 'spec_helper'

describe VimColorScheme::CommentNode do
  let :single_line_comment do
    comment = VimColorScheme::CommentNode.new "This is a comment!"
    comment.to_s
  end

  let :multi_line_comment do
    comment = VimColorScheme::CommentNode.new "This is.\nA multiline.\nComment."
    comment.to_s
  end

  it 'should put the comment character on the front of a comment' do
    single_line_comment.should == '" This is a comment!' + "\n"
  end

  it 'should render multiline comments properly' do
    multi_line_comment.should == '" This is.' + "\n" + '" A multiline.' +
      "\n" + '" Comment.' + "\n"
  end
end
