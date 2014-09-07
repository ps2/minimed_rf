require 'spec_helper'

describe MinimedRF::PumpStatusAck do

  it "should decode fields" do
    hex_data = "020006950004000000"
    message = MinimedRF::PumpStatusAck.from_hex(hex_data)
    expect(message.sequence).to eq 2
  end

end
