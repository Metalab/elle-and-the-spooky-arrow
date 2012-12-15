require 'usb'
require 'ostruct'

class Joystick
  attr_accessor :state
  def initialize
    @dev = USB.devices.select{|d| d.idVendor==0x046d && d.idProduct==0xc21a}.first
    work
  end

  def action
    _state = @state.dup
    @state = nil
    _state
  end

  def work
    Thread.start do
      @dev.open do |h|

        h.usb_detach_kernel_driver_np(0,0) rescue nil
        data = (0..3).to_.a.pack("C*")
        endpoint = @dev.endpoints.first.bEndpointAddress

        # clear anything in the buffer
        loop do
          begin
            size = handle.usb_interrupt_read(endpoint, data, -1)
          rescue
            break
          end
        end

        actions = Array.new
        actions << Proc.new { |state| @state = 'left'   if state[2] == 0x00 && state[3] == 0x04 }
        actions << Proc.new { |state| @state = 'right'  if state[0] == 0xFF }
        actions << Proc.new { |state| @state = 'up'     if state[2] == 0x00 && state[3] == 0x10}
        actions << Proc.new { |state| @state = 'down'   if state[1] == 0xFF }
        actions << Proc.new { |state| @state = 'red'    if (state[2] & 0x01) == 0x01 }
        actions << Proc.new { |state| @state = 'yellow' if (state[2] & 0x02) == 0x02 }
        actions << Proc.new { |state| @state = 'green'  if (state[2] & 0x04) == 0x04 }
        actions << Proc.new { |state| @state = 'blue'   if (state[2] & 0x08) == 0x08 }
        actions << Proc.new { |state| @state = 'l1'     if (state[2] & 0x10) == 0x10 }
        actions << Proc.new { |state| @state = 'r1'     if (state[2] & 0x20) == 0x20 }
        actions << Proc.new { |state| @state = 'l2'     if (state[2] & 0x40) == 0x40 }
        actions << Proc.new { |state| @state = 'r2'     if (state[2] & 0x80) == 0x80 }
        actions << Proc.new { |state| @state = 'select' if (state[3] & 0x01) == 0x01 }
        actions << Proc.new { |state| @state = 'start'  if (state[3] & 0x02) == 0x02 }

        loop do
          begin
            h.usb_bulk_read(endpoint, data, 10)
            state_array = data.unpack("C*")
            actions.each { |a| a.call(state_array) }
          rescue Errno::ETIMEDOUT => e
          rescue Interrupt
            exit 130
          end
          sleep(0.1)
        end
      end
    end
  end
end


j = Blinkofant::Pong::Joystick.new