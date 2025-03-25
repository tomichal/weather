module CacheHelper
  def with_cache_store(&block)
    original_cache_store = Rails.cache
    original_cache_config = Rails.application.config.cache_store
    original_caching_status = Rails.application.config.action_controller.perform_caching

    Rails.application.config.action_controller.perform_caching = true
    Rails.application.config.cache_store = :memory_store
    Rails.cache = ActiveSupport::Cache.lookup_store(:memory_store)

    begin
      yield
    ensure
      Rails.application.config.action_controller.perform_caching = original_caching_status
      Rails.application.config.cache_store = original_cache_config
      Rails.cache = original_cache_store
    end
  end
end
