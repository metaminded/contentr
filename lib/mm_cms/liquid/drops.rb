# coding: utf-8

module MmMmCmsLiquid::Drops end

# Load all the drops of the library
#
Dir[File.dirname(__FILE__) + '/drops/*.rb'].each { |f| require f }