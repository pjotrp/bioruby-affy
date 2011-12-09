
module Bio

  module Affy

    module Find 
      def Find.probeset_by_feature_name cdf, name
        num_probesets = Bio::Affy::Ext.cdf_num_probesets(cdf)
        (0..num_probesets-1).each do | i |
          probeset_ptr = Bio::Affy::Ext.cdf_probeset_info(cdf,i)
          probeset = Bio::Affy::CDFProbeSet.new(probeset_ptr)
          return i if probeset.name == name
        end
        nil
      end
    end

  end

end
