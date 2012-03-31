# coding: utf-8

module Contentr
  class File
    include Mongoid::Document

    # Fields
    field :description, :type => String
    field :slug,        :type => String, unique: true
    field :file,        :type => String
    
    mount_uploader :file, Contentr::FileUploader
    
    def actual_file()
      ::File.join(Rails.root, 'public', file_url())
    end

  end
end
