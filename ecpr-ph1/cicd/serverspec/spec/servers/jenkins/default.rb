require 'spec_helper'

describe "jenkins" do
  describe port(22) do
    it { should be_listening }
  end
 
  describe port(8080) do
    it { should be_listening }
  end
  
  describe service('jenkins') do
    it { should be_enabled }
    it { should be_running }
  end
 
end
