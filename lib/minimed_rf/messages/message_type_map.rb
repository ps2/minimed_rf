module MinimedRF
  MessageTypeMap = {
    0x01 => Alert,
    0x02 => AlertCleared,
    0x03 => DeviceTest,
    0x04 => PumpStatus,
    #0x05 => PumpStatus2,    # 2015-02-26T21:26:48Z       a2 597055 05 ee040063070a000f021a00ee1326000f021901091115000f021901121021000f02190000 2e
    0x06 => PumpStatusAck,
    #0x08 => DumpPumpInfo,   # 2014-09-08T23:14:55-0500 - a2 597055 08 765000ff80ff80ff80ff80ff80ff80ff80e600ff80ff80ff80ff80ff80ff80ff80 6d
    0x09 => FindDevice,      # From pump
    0x0a => DeviceLink,      # From linking device
    0x0b => PumpDump,       # 2014-09-08T23:14:57-0500 - a2 597055 0b 780001a7a7a7aaa39c9b9a9a9a9a9a9a9a9998979798999ea0a09c100000f2c1eb000000 41
    0x8d => GetModel,
    0x5d => WakeUp,
  }

  MessageTypeMap.values.each { |m| m.check_bit_block_definitions }
end
