require 'spec_helper'

describe MinimedRF::GlucoseSensorMessage do

  it "should decode fields" do
    hex_data = "9041040d240e0718006a6d00022103020683068a051500000172008b040b000e07180000"
    message = MinimedRF::GlucoseSensorMessage.from_hex(hex_data)
    expect(message.glucose).to eq 213
    expect(message.previous_glucose).to eq 218
    expect(message.timestamp).to eq Time.parse('2014-07-24 04:11:00')
  end

end
