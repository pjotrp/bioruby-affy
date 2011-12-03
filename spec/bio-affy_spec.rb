ROOT = File.dirname(__FILE__)
$: << File.join([ROOT, "..","lib"])
# ENV['LD_LIBRARY_PATH'] = File.join([ROOT, "..","lib"])

require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'bio-affy'

describe "BioAffy" do
  it "should open a CDF file" do
    @cdf = Bio::Affy::Ext.open_cdffile("test_cdf.dat.gz")
  end
  it "should open a CEL file"
  it "should find the probe values"
  it "should name the probes"
end
