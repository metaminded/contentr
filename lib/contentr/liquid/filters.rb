# coding: utf-8

module Contentr::Liquid::Filters end

Dir[File.dirname(__FILE__) + '/filters/*.rb'].each { |f| require f }