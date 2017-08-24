require "spec_helper"

RSpec.describe WOSClient do
  it "has a version number" do
    expect(WOSClient::VERSION).not_to be nil
  end

  it "does something useful" do
    expect(false).to eq(true)
  end
end
