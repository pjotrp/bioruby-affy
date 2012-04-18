require 'mkrf'
Mkrf::Generator.new('libaffyext') do | mkrf |
  # compile flags
  mkrf.cflags << `R CMD config --cppflags`.strip
  # disable these checks for Ruby 1.9.3
  mkrf.cflags.gsub!(/-Werror=declaration-after-statement/,'')
  mkrf.cflags.gsub!(/-Werror=implicit-function-declaration/,'')
  # link flags
  mkrf.ldshared << `R CMD config --ldflags`.strip
end
