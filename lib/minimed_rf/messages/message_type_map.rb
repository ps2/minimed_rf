module MinimedRF
  MessageTypeMap = {
    0x04 => GlucoseSensorMessage
  }

  MessageTypeMap.values.each { |m| m.check_bit_block_definitions }
end
