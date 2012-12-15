require_relative 'screen'
require_relative 'device'

s = Screen.new
d = Device.new(s)

s.col(0, true)
d.flush

while true do
  s.shift_cols
  d.flush
  sleep(0.1)
end
