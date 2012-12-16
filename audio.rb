require 'ffi'
require 'ffi-portaudio'
require_relative 'lib/ffi-pd'

class Audio
  def initialize(file_name)
    @file_name = file_name
    @arrow = arrow
    init!

    Stream.new
  end

  def update_arrow
    notes = [67, 65, 60]
    Pd.send_float('arrow-note', notes[@arrow.lane])
    Pd.send_bang('arrow')
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
