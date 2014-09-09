module MinimedRF
  MessageTypeMap = {
    0x01 => Alert,
    0x02 => AlertCleared,
    0x04 => PumpStatus,
    0x06 => PumpStatusAck,
    0x09 => FindDevice,    # From pump
    0x0a => DeviceLink     # From linking device
  }

  MessageTypeMap.values.each { |m| m.check_bit_block_definitions }
end
