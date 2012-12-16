require 'ffi'
require 'ffi-portaudio'
require_relative 'lib/ffi-pd'

class Audio
  def initialize(file_name)
    @file_name = file_name

    init!
    Stream.new
  end

  def init_entities(arrow, guy)
    @arrow = arrow
    arrow_on
    @guy = guy
    guy_on
  end

  def arrow_on
    @arrow_lane = @arrow.lane
    update_arrow
    Pd.send_bang('arrow-on')
  end

  def arrow_off
    Pd.send_bang('arrow-off')
  end

  def update_arrow
    if @arrow.lane != @arrow_lane
      notes = [67, 65, 60]
      Pd.send_float('arrow-note', notes[@arrow.lane])
      @arrow_lane = @arrow.lane
    end
  end

  def explosion
    Pd.send_bang('explosion')
  end

  def update_j1(state)
    case state
    when :up
      Pd.send_float('j1', 79)
    when :down
      Pd.send_float('j1', 72)
    end
  end

  def distance
    arrow_front_col = @arrow.body[4][0]
    guy_back_col = @guy.body[0][0]
    distance = (guy_back_col - arrow_front_col).abs
    if distance >= 16
      if guy_back_col >= 16
        distance = 31 - guy_back_col + arrow_front_col
      else
        distance = 31 - arrow_front_col + guy_back_col
      end
    end
    distance
  end

  def guy_on
    Pd.send_float('guy-distance', distance)
    Pd.send_bang('guy-on')
  end

  def guy_off
    Pd.send_bang('guy-off')
  end

  def update_guy
    Pd.send_float('guy-distance', distance.to_f)
  end

  def init!
    Pd.init
    Pd.init_audio(0, 2, 44100)
    Pd.open(@file_name, '.')

    Pd.start_message(1)
    Pd.add_float(1.0)
    Pd.finish_message('pd', 'dsp')
  end
end

class Stream < FFI::PortAudio::Stream
  include FFI::PortAudio

  def initialize(channel_count = 2, sample_rate = 44100, buffer_size = 256)
    init!(channel_count, sample_rate, buffer_size)
    @output_buffer = FFI::Buffer.new :float, buffer_size * 2

    start
  end

  def process(input, output, buffer_size, time_info, status_flags, user_data)
    Pd.process_float(buffer_size / 64, nil, output)

    :paContinue
  end

  def init!(channel_count, sample_rate, buffer_size)
    API.Pa_Initialize

    output_parameters = API::PaStreamParameters.new
    output_parameters[:device] = API.Pa_GetDefaultOutputDevice
    output_parameters[:suggestedLatency] = API.Pa_GetDeviceInfo(output_parameters[:device])[:defaultHighOutputLatency]
    output_parameters[:hostApiSpecificStreamInfo] = nil
    output_parameters[:channelCount] = channel_count
    output_parameters[:sampleFormat] = API::Float32

    open(nil, output_parameters, sample_rate, buffer_size)

    at_exit do
      close
      FFI::PortAudio::API.Pa_Terminate
    end
  end
end
