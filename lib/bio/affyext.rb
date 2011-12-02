
module Bio

  module Affy

    module Ext

      extend FFI::Library
      DIR = File.dirname(__FILE__)

      ffi_lib File.join(DIR,'libaffyext.so')  # <-- fix for OSX
      ffi_convention :stdcall

      # attach_function :message_box, :MessageBoxA,[ :pointer, :string, :string, :uint ], :int

    end

  end

end
