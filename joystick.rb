require 'fcntl'

class Joystick
  attr_accessor :state

  def initialize
    @device = "/dev/input/js0"
    @fd = IO::sysopen(@device, Fcntl::O_RDONLY)
    work
  end

  def actions
    actions = Array.new
    actions << Proc.new { |state| print 'left'   if state[7] == 0x00 && state[5] == 0x80 }
    actions << Proc.new { |state| print 'right'  if state[7] == 0x00 && state[5] == 0x7F }
    actions << Proc.new { |state| print 'up'     if state[7] == 0x01 && state[5] == 0x80 }
    actions << Proc.new { |state| print 'down'   if state[7] == 0x01 && state[5] == 0x7F }
    actions << Proc.new { |state| print 'red'    if state[7] == 0x01 && state[6] == 0x01}
    actions << Proc.new { |state| print 'yellow' if state[7] == 0x02 && state[6] == 0x01 }
    actions << Proc.new { |state| print 'green'  if state[7] == 0x03 && state[6] == 0x01 }
    actions << Proc.new { |state| print 'blue'   if state[7] == 0x00 && state[6] == 0x01 }
    actions << Proc.new { |state| print 'l1'     if state[7] == 0x06 && state[6] == 0x01 }
    actions << Proc.new { |state| print 'r1'     if state[7] == 0x07 && state[6] == 0x01 }
    actions << Proc.new { |state| print 'select' if state[7] == 0x08 && state[6] == 0x01 }
    actions << Proc.new { |state| print 'start'  if state[7] == 0x09 && state[6] == 0x01 }
    actions
  end

  def action
    _state = @state.dup
    @state = nil
    _state
  end

  def work
    f = IO.open(@fd)
    loop {
      data = f.read(8).unpack("C*")
      actions.each { |a| a.call(data) }
    }
  end
end

j = Joystick.new