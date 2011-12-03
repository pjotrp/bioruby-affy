require 'mkrf'
Mkrf::Generator.new('libaffyext') do | mkrf |
  mkrf.cflags << `R CMD config --cppflags`.strip
  # disable these chechs for Ruby 1.9.3
  mkrf.cflags.gsub!(/-Werror=declaration-after-statement/,'')
  mkrf.cflags.gsub!(/-Werror=implicit-function-declaration/,'')
  mkrf.ldshared << `R CMD config --ldflags`.strip
end
