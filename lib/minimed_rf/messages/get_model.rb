
module MinimedRF
  class GetModel < Message

    def model
      if @data.bytesize > 3
        len = @data.getbyte(1)
        return @data.byteslice(2,len)
      end
    end

    def to_s
      "GetModel: #{model.inspect}"
    end
  end
end
