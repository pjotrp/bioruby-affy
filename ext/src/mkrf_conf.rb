require 'mkrf'
Mkrf::Generator.new('libbio-affy') do | mkrf |
  mkrf.cflags << `R CMD config --cppflags`.strip
  mkrf.ldshared << `R CMD config --ldflags`.strip
end
