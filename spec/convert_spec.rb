require 'rspec'

require File.join(File.expand_path("..", File.dirname(__FILE__)), 'convert.rb')


describe "source_url()" do
  it "should be convert page url to source url" do
    source_url("http://www.example.com/trac/sample/wiki/foo").should == "http://www.example.com/trac/sample/wiki/foo?format=txt"
    source_url("http://www.example.com/trac/sample/wiki"    ).should == "http://www.example.com/trac/sample/wiki/WikiStart?format=txt"
    source_url("http://www.example.com/trac/sample"         ).should == "http://www.example.com/trac/sample/wiki/WikiStart?format=txt"
  end
end


