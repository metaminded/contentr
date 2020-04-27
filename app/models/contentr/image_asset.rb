class Contentr::ImageAsset < ActiveRecord::Base

  def publish!
    if file_unpublished.blank? && file.present?
      remove_file!
    else
      self.file = file_unpublished
    end
    save!
  end

  def revert!
    self.update(file_unpublished: file)
  end

  def unpublished_changes?
    # check presence of object in db
    return false if !file.present? && !file_unpublished.present?
    return true  if !(file.present? && file_unpublished.present?)

    # check for files in memory
    return false if !file_unpublished.file.present? # the unpublished file was lost on disk, publishing would break
    return true  if !file.file.present?             # the published file was lost on disk, publish again to restore
    return !FileUtils.identical?(file.file.file, file_unpublished.file.file)
  end

end
