require 'mkrf'
Mkrf::Generator.new('libaffyext') do | mkrf |
  mkrf.cflags << `R CMD config --cppflags`.strip
  mkrf.cflags.gsub!(/-Werror=declaration-after-statement/,'')
  mkrf.ldshared << `R CMD config --ldflags`.strip
end
