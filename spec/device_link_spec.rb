require 'spec_helper'

describe MinimedRF::DeviceLink do

  it "should decode fields" do
    message = MinimedRF::DeviceLink.from_hex("3700069500")
    expect(message.sequence).to eq 55
    expect(message.device_address).to eq "000695"
  end

end
