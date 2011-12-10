ROOT = File.dirname(File.dirname(__FILE__))
$: << File.join([ROOT, "lib"])
# ENV['LD_LIBRARY_PATH'] = File.join([ROOT, "..","lib"])

require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'bio-affy'

DATADIR = File.join([ROOT,'test','data','affy'])
CDF = File.join(DATADIR,"MG_U74Av2.CDF")    # GPL81
CDF2 = File.join(DATADIR,"ATH1-121501.CDF")
CEL1 = File.join(DATADIR,"GSM103328.CEL.gz")

describe "Bio::Affy::Ext1" do
 
  it "should find the shared library" do
    Bio::Affy::Ext.has_affyext(5).should == 60
  end
end

describe "Bio::Affy::Ext" do
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
  it "should find the CDF cel intensity value" do
    # In Bioconductor, after m <- ReadAffy()
    #
    intensity = Bio::Affy::Ext.cel_intensity(@cel,1510)
    intensity.should == 10850.8
  end
  it "should get the probeset indexes from the CDF" do
    cdf_cols = 640 # (cdf.cols)
    # R/Bioconductor:
    #
    # > as.vector(geneNames(m))[11657]
    # [1] "98910_at"
    # 
    # cat(indexProbes(m, which="pm", genenames="98910_at")[[1]],sep=",")
    # 344297,177348,21247,246762,200777,166097,382469,397538,66238,344987,11503,253234,206965,103391,54927,333474
    #
    # or
    #
    # pmindex(m,"98910_at")
    #

    pm0 = [ 344297,177348,21247,246762,200777,166097,382469,397538,66238,344987,11503,253234,206965,103391,54927,333474 ]
    pm0.each_with_index do | index, i |
      # call with probeset, probenum
      probe_ptr = Bio::Affy::Ext.cdf_pmprobe_info(@cdf,1510,i)
      probe = Bio::Affy::CDFProbeInfo.new(probe_ptr)
      # p [probe.x, probe.y]
      # p [ index, probe.x, probe.y, probe.x + probe.y*@cdf.cols + 1]
      (probe.x + probe.y*cdf_cols + 1).should == index
    end

    
  end

  it "should get the probeset information" do
    # In Bioconductor, after m <- ReadAffy()
    #
    # > length(featureNames(m))
    # [1] 12488  (12501 in bio-affy - we add the 13 controls)
    #
    # Note also the feature numbering is different in the Bioconductor set:
    # > as.vector(geneNames(m))[0:5]
    # [1] "100001_at" "100002_at" "100003_at" "100004_at" "100005_at"
    # > as.vector(geneNames(m))[1509:1512]
    # [1] "101947_at" "101948_at" "101949_at" "101950_at"
    # > as.vector(geneNames(m))[11657]
    # [1] "98910_at"  <- this is what we test at index 1510.
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
    #  mypmindex <- pmindex(m,"98910_at")
    #  cat(intensity(m)[mypmindex$`98910_at`],sep=",")
    # Bioconductor 1.9 - even with test.cdf ought to be

    pms = [ 120,768,1046,1220.3,345.3,171.3,138,171.3,189,343.3,605.3,1064.5,4429.3,854.3,2675,886.3]
    pms.each_with_index do | e, i |
      # p Biolib::Affyio.cel_pm(@microarrays[1],@cdf,1510,i)
      Bio::Affy::Ext.cel_pm(@cel,@cdf,1510,i).should == e
    end
  end
  # convenience methods
  it "should find the probeset for 98910_at" do
    probeset_index = Bio::Affy::Find.probeset_by_feature_name(@cdf,"98910_at")
    probeset_index.should == 1510
  end
end


