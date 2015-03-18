require 'spec_helper'

RSpec.describe Contentr::PagesController, type: :controller do

  describe "GET index" do
    after{
      I18n.locale = I18n.default_locale
    }

    it 'gets the page with different locales' do
      contentpage = create(:contentpage)

      get(:index, slug: contentpage.slug)
      expect(response).to have_http_status('200')

      get(:index, slug: contentpage.slug, locale: 'en')
      expect(response).to have_http_status('200')

      get(:index, slug: contentpage.slug, locale: 'de')
      expect(response).to have_http_status('200')
    end
  end
end
