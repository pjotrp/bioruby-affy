ROOT = File.dirname(File.dirname(__FILE__))
$: << File.join([ROOT, "lib"])
# ENV['LD_LIBRARY_PATH'] = File.join([ROOT, "..","lib"])

require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'bio-affy'

DATADIR = File.join([ROOT,'test','data','affy'])
CDF = File.join(DATADIR,"MG_U74Av2.CDF")    # GPL81
CDF2 = File.join(DATADIR,"ATH1-121501.CDF")
CEL1 = File.join(DATADIR,"GSM103328.CEL.gz")

describe "Bio::Affy::Ext" do
 
  it "should find the shared library" do
    Bio::Affy::Ext.has_affyext(5).should == 60
  end
end

describe "BioAffy" do
  before :all do 
    # first start the R environment
    Bio::Affy::Ext.BioLib_R_Init()
    # load the CDF once
    @cdf = Bio::Affy::Ext.open_cdffile(CDF)
    # load a CEL file once
    @cel = Bio::Affy::Ext.open_celfile(CEL1)
  end
  it "should open a CDF file" do
    @cdf.null?.should == false
  end
  it "should count the probesets" do
    # Open the Mouse CDF file - in Bioconductor this would be
    #
    #   source("http://bioconductor.org/biocLite.R")
    #   biocLite("affy")
    #   library(affy)
    #   library(makecdfenv)
    #   make.cdf.package('test.cdf',species='test')
    #   exit and R CMD INSTALL testcdf/
    #   m <- ReadAffy(cdfname='test')
    #
    # because CDF files are not read directly. bio-affy, however can:
    num_probesets = Bio::Affy::Ext.cdf_num_probesets(@cdf)
    num_probesets.should == 12501
  end
  it "should open a CEL file" do
    # Open the Mouse CEL files - in Bioconductor this would be
    #
    #   source("http://bioconductor.org/biocLite.R")
    #   biocLite("affy")
    #   library(affy)
    #   m <- ReadAffy()
    #   dim(m)
    #     Cols Rows 
    #     640  640  == 409600

    num = Bio::Affy::Ext.cel_num_intensities(@cel)
    num.should == 409600 
  end
  it "should find the probe intensity values" do
    # In Bioconductor, after m <- ReadAffy()
    #
    probe_value = Bio::Affy::Ext.cel_intensity(@cel,1510)
    probe_value.should == 10850.8
  end
  it "should get the probeset information through Ext" do
    # In Bioconductor, after m <- ReadAffy()
    #
    #   geneNames(m)[1]     "1007_s_at"
    #   geneNames(m)[1]     "1007_s_at"
    #   geneNames(m)[1511]  "215738_at"
    #   geneNames(m)[15111] "215738_at"
    #   geneNames(m)[21232] "221872_at"
    # memptr = MemoryPointer.new :pointer
    probeset_ptr = Bio::Affy::Ext.cdf_probeset_info(@cdf,1510)
    probeset = Bio::Affy::CDFProbeSet.new(probeset_ptr)
    probeset[:isQC].should == 0
    probeset[:pm_num].should == 16
    probeset[:mm_num].should == 16
    # 98910_at	144	P	0.009985 (normalized on GEO)
    probeset[:name].to_ptr.read_string.should == "98910_at"
    # now use the convenience methods
    probeset.name.should == "98910_at"
  end
  it "should fetch the PM (perfect match) values" do
    # Test PM values; as in R's pm(m)[1,1:8]
    #  mypmindex <- pmindex(m,"AFFX-BioB-5_at")
    #  intensity(m)[mypmindex$`AFFX-BioB-5_at`,2]
    # Bioconductor 1.9 - even with test.cdf ought to be

    pms = [ 665,655.8,591.3,117.5,697.8,1220.8,2763.8,2765.3,2989.3,875.8,625,229,261.3,109.8,801.3,258.3,433.3,186.8,227.5,662 ]
    pms.each_with_index do | e, i |
      # p Biolib::Affyio.cel_pm(@microarrays[1],@cdf,1-1,i)
      Bio::Affy::Ext.cel_pm(@cel,@cdf,1-1,i).should == e
    end
  end
end
