require 'spec_helper'

describe MinimedRF::AlertCleared do

  it "should decode fields" do
    message = MinimedRF::AlertCleared.from_hex("4a72")
    expect(message.sequence).to eq 0x4a
    expect(message.alert_type).to eq :high_predicted
  end

end
