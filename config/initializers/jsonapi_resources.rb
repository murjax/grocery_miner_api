JSONAPI.configure do |config|
  config.json_key_format = :underscored_key
  config.default_paginator = :paged
  config.top_level_links_include_pagination = true
  config.top_level_meta_include_record_count = true
  config.top_level_meta_include_page_count = true
  config.top_level_meta_page_count_key = :total_pages
end
