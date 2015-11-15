require 'spec_helper'

describe MinimedRF::Alert do

  it "should decode fields" do
    message = MinimedRF::Alert.from_hex("e333153b1d0e09085200")
    expect(message.sequence).to eq 99
    expect(message.alert_type).to eq :max_hourly_bolus
    expect(message.timestamp.year).to eq 2014
    expect(message.timestamp.month).to eq 9
    expect(message.timestamp.day).to eq 8
    expect(message.timestamp.hour).to eq 21
    expect(message.timestamp.min).to eq 59
    expect(message.timestamp.sec).to eq 29
  end

end
