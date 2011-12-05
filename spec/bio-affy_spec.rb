ROOT = File.dirname(File.dirname(__FILE__))
$: << File.join([ROOT, "lib"])
# ENV['LD_LIBRARY_PATH'] = File.join([ROOT, "..","lib"])

require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'bio-affy'

DATADIR = File.join([ROOT,'test','data','affy'])
CDF = File.join(DATADIR,"MG_U74Av2.CDF")
CDF2 = File.join(DATADIR,"ATH1-121501.CDF")
CEL1 = File.join(DATADIR,"GSM103328.CEL.gz")

describe "BioAffy" do
  it "should find the shared library" do
    Bio::Affy::Ext.has_affyext(5).should == 60
  end
  it "should open a CDF file" do
    Bio::Affy::Ext.BioLib_R_Init()
    cdf = Bio::Affy::Ext.open_cdffile(CDF)
    cdf.null?.should == false
    num_probesets = Bio::Affy::Ext.cdf_num_probesets(cdf)
    num_probesets.should == 12501
  end
  it "should open a CEL file" do
    cel1 = Bio::Affy::Ext.open_celfile(CEL1)
    num = Bio::Affy::Ext.cel_num_intensities(cel1)
    num.should == 409600 
  end
  it "should find the probe value for 1511" do
    cel = Bio::Affy::Ext.open_celfile(CEL1)
    probe_value = Bio::Affy::Ext.cel_intensity(cel,1510)
    probe_value.should == 10850.8
  end
  it "should name the probes for 1511" do
    cdf = Bio::Affy::Ext.open_cdffile(CDF)
    # memptr = MemoryPointer.new :pointer
    probeset_ptr = Bio::Affy::Ext.cdf_probeset_info(cdf,1510)
    probeset = Bio::Affy::CDFProbeSet.new(probeset_ptr)
    probeset[:isQC].should == 0
    probeset[:pm_num].should == 16
    probeset[:mm_num].should == 16
    probeset[:name].to_ptr.read_string.should == "98910_at"
  end
end
