class BaseController < ApplicationController
  DEFAULT_ITEMS = Kaminari::config.default_per_page
  include Error::ErrorHandler
end