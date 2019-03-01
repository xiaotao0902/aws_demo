require 'spec_helper'

describe "gitlib-app" do
  describe command("curl -i #{property[:endpoint]}") do
  # should match /"status":201/
	its(:stdout) { should match(%r|HTTP/1.1 302 Found|) }

  end

end
