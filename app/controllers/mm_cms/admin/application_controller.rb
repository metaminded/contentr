# coding: utf-8

class MmCms::Admin::ApplicationController < MmCms::ApplicationController

  layout proc { |c| c.request.xhr? ? false : 'mm_cms/admin' }

end