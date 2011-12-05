
module Bio

  module Affy

    module Ext

      extend FFI::Library
      DIR = File.dirname(__FILE__)

      ffi_lib File.join(DIR,'libaffyext.so')  # <-- fix for OSX
      ffi_convention :stdcall

      attach_function :has_affyext, [ :int ], :int
      attach_function :BioLib_R_Init, [], :void
      attach_function :BioLib_R_Close, [], :void
      attach_function :open_cdffile, [ :string ], :pointer
      attach_function :open_celfile, [ :string ], :pointer
      attach_function :cel_intensity, [ :pointer, :int ], :double
      attach_function :cdf_probeset_info, [ :pointer, :int ], :pointer
    end

  end

end
