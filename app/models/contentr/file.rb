# coding: utf-8
require "carrierwave"
module Contentr
  class File < ActiveRecord::Base
    # Fields
    attr_accessible :description, :slug, :file

    validates_uniqueness_of :slug

    mount_uploader :file, Contentr::FileUploader
    
    # Public: Generates the actual file path
    # 
    # Return the generated path
    def actual_file()
      ::File.join(Rails.root, 'public', file_url())
    end

  end
end
