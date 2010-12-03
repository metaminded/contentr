# coding: utf-8

module MmCms::Liquid::Drops end

Dir[File.dirname(__FILE__) + '/drops/*.rb'].each { |f| require f }