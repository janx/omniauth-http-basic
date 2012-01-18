require File.expand_path('../../../spec_helper', __FILE__)

describe OmniAuth::Strategies::HttpBasic do
  def app; lambda {|env| [200, {}, ["Hello HttpBasic!"]]}; end

  let(:fresh_strategy) { Class.new OmniAuth::Strategies::HttpBasic }
  subject { fresh_strategy }

  it 'should be initialized with authentication endpoint' do
    instance = subject.new(app, "http://www.example.com/httpauth")
    instance.options.endpoint.should == "http://www.example.com/httpauth"
  end
end
