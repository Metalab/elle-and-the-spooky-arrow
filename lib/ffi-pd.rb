require 'ffi'

module Pd
  extend FFI::Library

  ffi_lib 'pd'

  attach_function :init, :libpd_init, [], :void

  attach_function :open, :libpd_openfile, [:string, :string], :pointer

  attach_function :init_audio, :libpd_init_audio, [:int, :int, :int], :int
  attach_function :process_float, :libpd_process_float, [:int, :buffer_inout, :buffer_inout], :int

  attach_function :send_bang, :libpd_bang, [:string], :int
  attach_function :send_float, :libpd_float, [:string, :float], :int

  attach_function :start_message, :libpd_start_message, [:int], :int
  attach_function :add_float, :libpd_add_float, [:float], :void
  attach_function :finish_message, :libpd_finish_message, [:string, :string], :int
end
