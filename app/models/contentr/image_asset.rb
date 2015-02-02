class Contentr::ImageAsset < ActiveRecord::Base

  def publish!
    if file_unpublished.blank? && file.present?
      remove_file!
    else
      self.file = file_unpublished
    end
    save!
  end

  def unpublished_changes?
    return false if !file.present? && !file_unpublished.present?
    return true  if !(file.present? && file_unpublished.present?)
    logger.info "comparing #{file.file.file} and #{file_unpublished.file.file}"
    !FileUtils.compare_file file.file.file, file_unpublished.file.file
  end

end
