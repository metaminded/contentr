# coding: utf-8

module Contentr
  class PageWithoutContent < Page

    validate :has_no_paragraphs

    private

    def has_no_paragraphs
     errors.add(:base, :has_paragraphs) if self.paragraphs.any?
    end
  end
end
