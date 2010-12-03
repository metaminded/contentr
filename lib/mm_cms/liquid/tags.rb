# coding: utf-8

module MmCms::Liquid::Tags end

Dir[File.dirname(__FILE__) + '/tags/*.rb'].each { |f| require f }