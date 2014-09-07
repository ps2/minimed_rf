module MinimedRF
  MessageTypeMap = {
    0x04 => PumpStatus,
    0x06 => PumpStatusAck
  }

  MessageTypeMap.values.each { |m| m.check_bit_block_definitions }
end
