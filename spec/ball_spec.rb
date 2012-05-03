require 'spec_helper'
require 'lib/ball'

describe Ball do
  it 'instance is class Ball' do
    ball = Ball.new
    ball.should be_an_instance_of Ball
  end

  it "store and read x, y" do
    ball = Ball.new :x=>1, :y=>2
    ball.x.should == 1
    ball.y.should == 2
  end

end
