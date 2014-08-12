require 'minimed_rf/messages/message_base'
require 'minimed_rf/messages/glucose_sensor_data'

module MinimedRF
  class Messages
    MAP = {
      0xa2 => GlucoseSensorData
    }
  end
end
