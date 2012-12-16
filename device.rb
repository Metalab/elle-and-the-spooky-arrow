require 'wiringpi'
require 'fcntl'

class Device
  SPI_IOC_WR_MAX_SPEED_HZ = 0x40046b04
  DARKEN_PIN = 6

  def initialize(screen)
    @screen = screen
    init_spi
    init_gpio
  end

  def init_spi
    @device = '/dev/spidev0.0'
    @fd = IO::sysopen(@device, Fcntl::O_WRONLY)
    @f = IO.open(@fd)
    @f.sync = true
    @f.ioctl(SPI_IOC_WR_MAX_SPEED_HZ, [100_000].pack("L"))
  end

  def init_gpio
    @io = WiringPi::GPIO.new
    @io.mode(DARKEN_PIN,OUTPUT)
  end

  def flush
    packed_stream = @screen.bit_stream.pack("C*")

    @io.write(DARKEN_PIN,LOW)
    @f.write(packed_stream)
    @io.write(DARKEN_PIN,HIGH)

    @screen.reset
  end
end
