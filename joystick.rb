require 'fcntl'

class Joystick
  attr_accessor :state

  def initialize(device = "/dev/input/js0")
    @device = device
    @fd = IO::sysopen(@device, Fcntl::O_RDONLY)
    work
  end

  def action
    _state = @state
    @state = nil
    _state
  end

  def actions
    actions = Array.new
    actions << Proc.new { |state| @state = :left   if state[7] == 0x00 && state[5] == 0x80 }
    actions << Proc.new { |state| @state = :right  if state[7] == 0x00 && state[5] == 0x7F }
    actions << Proc.new { |state| @state = :up     if state[7] == 0x01 && state[5] == 0x80 }
    actions << Proc.new { |state| @state = :down   if state[7] == 0x01 && state[5] == 0x7F }
    actions << Proc.new { |state| @state = :red    if state[7] == 0x01 && state[6] == 0x01}
    actions << Proc.new { |state| @state = :yellow if state[7] == 0x02 && state[6] == 0x01 }
    actions << Proc.new { |state| @state = :green  if state[7] == 0x03 && state[6] == 0x01 }
    actions << Proc.new { |state| @state = :blue   if state[7] == 0x00 && state[6] == 0x01 }
    actions << Proc.new { |state| @state = :l1     if state[7] == 0x06 && state[6] == 0x01 }
    actions << Proc.new { |state| @state = :r1     if state[7] == 0x07 && state[6] == 0x01 }
    actions << Proc.new { |state| @state = :select if state[7] == 0x08 && state[6] == 0x01 }
    actions << Proc.new { |state| @state = :start  if state[7] == 0x09 && state[6] == 0x01 }
    actions
  end

  def work
    f = IO.open(@fd)
    Thread.new {
      loop {
        data = f.read(8).unpack("C*")
        actions.each { |a| a.call(data) }
      }
    }
  end
end
