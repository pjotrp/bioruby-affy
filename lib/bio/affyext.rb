
module Bio

  module Affy

    class CDFProbeInfo < FFI::Struct
      layout :x, :uint,
             :y, :uint
      def x
        self[:x]
      end
      def y
        self[:y]
      end
    end

    class CDFProbeSet < FFI::Struct
      layout :isQC,    :int,
             :pm_num,  :int,
             :mm_num,  :int,
             :pm,      :pointer,
             :mm,      :pointer,
             :name,    [:uint8, 64] 

      def name 
        self[:name].to_ptr.read_string 
      end
    end

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
      attach_function :cel_num_intensities, [ :pointer ], :uint64
      attach_function :cdf_num_probesets, [ :pointer ], :uint64
      attach_function :cdf_probeset_info, [ :pointer, :int ], :pointer
      attach_function :cel_pm, [:pointer, :pointer, :int, :int ], :double
      attach_function :cdf_pmprobe_info, [:pointer, :int, :int], :pointer
      # more bindings are available, check out the functions defined in ./ext/src
      # and the biolib test_affyio.rb file
    end

  end

end
