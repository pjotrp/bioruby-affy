ROOT = File.dirname(__FILE__)
$: << File.join([ROOT, "..","lib"])
# ENV['LD_LIBRARY_PATH'] = File.join([ROOT, "..","lib"])

require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'bio-affy'

DATADIR = ROOT + File.join('test','data','affy')
CDF = DATADIR+"MG_U74Av2.CDF.gz"
CEL1 = DATADIR+"GSM103328.CEL.gz"

describe "BioAffy" do
  it "should find the shared library" do
    Bio::Affy::Ext.has_affyext(5).should == 60
  end
  it "should open a CDF file" do
    @cdf = Bio::Affy::Ext.open_cdffile(CDF)
  end
  it "should open a CEL file"
  it "should find the probe values"
  it "should name the probes"
end
