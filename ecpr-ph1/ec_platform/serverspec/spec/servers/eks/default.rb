require 'spec_helper'

describe "eks-app" do
  describe command("#{property[:cmd]}") do
	its(:stdout) { should match(%r||) }

  end

end
