
module Bio

  module Affy

    module Ext

      extend FFI::Library
      DIR = File.dirname(__FILE__)

      ffi_lib File.join(DIR,'libaffyext.so')  # <-- fix for OSX
      ffi_convention :stdcall

      attach_function :has_affyext, [ :int ], :int
      # attach_function :open_cdffile, [ :string ], :pointer
      def open_cdffile s
      end

    end

  end

end
