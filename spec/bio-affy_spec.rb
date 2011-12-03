ROOT = File.dirname(File.dirname(__FILE__))
$: << File.join([ROOT, "lib"])
# ENV['LD_LIBRARY_PATH'] = File.join([ROOT, "..","lib"])

require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'bio-affy'

DATADIR = File.join([ROOT,'test','data','affy'])
CDF = File.join(DATADIR,"MG_U74Av2.CDF.gz")
CEL1 = File.join(DATADIR,"GSM103328.CEL.gz")

describe "BioAffy" do
  it "should find the shared library" do
    Bio::Affy::Ext.has_affyext(5).should == 60
  end
  it "should open a CDF file" do
    Bio::Affy::Ext.BioLib_R_Init()
    @cdf = Bio::Affy::Ext.open_cdffile(CDF)
  end
  it "should open a CEL file"
  it "should find the probe values"
  it "should name the probes"
end
