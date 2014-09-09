require 'spec_helper'

describe MinimedRF::Alert do

  it "should decode fields" do
    message = MinimedRF::Alert.from_hex("e333153b1d0e09085200")
    expect(message.sequence).to eq 0xe3
    expect(message.alert_type).to eq :max_hourly_bolus
  end

end
