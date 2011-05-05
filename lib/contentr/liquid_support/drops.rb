# coding: utf-8

module Contentr::LiquidSupport::Drops end

Dir[File.dirname(__FILE__) + '/drops/*.rb'].each { |f| require f }