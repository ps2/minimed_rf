require 'spec_helper'

describe MinimedRF::PumpStatus do

  #923,7/24/14,04:11:00,7/24/14 04:11:00,,,,,,,,,,,,,,,,,,,,,,,,,,,213,39.64,,GlucoseSensorData,"AMOUNT=213, ISIG=39.64, VCNTR=-0.488, BACKFILL_INDICATOR=false",13537455052,53400304,461,MiniMed 530G - 551
  it "should decode fields" do
    hex_data = "9041040d240e0718006a6d00022103020683068a051500000172008b040b000e07180000"
    message = MinimedRF::PumpStatus.from_hex(hex_data)
    expect(message.sequence).to eq 16
    expect(message.sensor_status).to eq :ok
    expect(message.glucose).to eq 213
    expect(message.previous_glucose).to eq 218
    expect(message.timestamp).to eq Time.parse('2014-07-24 04:11:00')
  end

  it "should handle weak signal messages" do
    hex_data = "e0410f30090e08180002020003cc030307142523142a00000000006d0f2f000e08180000"
    message = MinimedRF::PumpStatus.from_hex(hex_data)
    expect(message.sensor_status).to eq :weak_signal
    expect(message.timestamp).to eq Time.parse('2014-08-24 15:47:00')
  end

  it "should handle meter bg now messages" do
    hex_data = "a04116211f0e081800010100037e030305f72c1cffff000c0000006e1620000e08180000"
    message = MinimedRF::PumpStatus.from_hex(hex_data)
    expect(message.sensor_status).to eq :meter_bg_now
    expect(message.timestamp).to eq Time.parse('2014-08-24 22:32:00')
  end

  it "should handle sensor missing messages" do
    hex_data = "3940080b240e090800000000050d030305b30000000000000000007a0000000000000000"
    message = MinimedRF::PumpStatus.from_hex(hex_data)
    expect(message.sensor_status).to eq :sensor_missing
    expect(message.timestamp).to eq nil
  end

end
