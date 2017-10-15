class SearchLimitChecker
  ALERT_MSG = 'Daily limit is reached. Please try again next day'.freeze
  class << self
    def limit_is_reached?
      store.get(db_key).to_i >= daily_limit
    end

    def search_is_performed
      store.incr(db_key)
    end

    private

    def daily_limit
      ENV['MAX_SEARCH_PER_DAY'].to_i
    end

    def db_key
      Time.zone.today.strftime('search_count_%d_%m_%y')
    end

    def store
      @redis ||= Redis.new(url: ENV['REDIS_DATA_STORE_URL'])
    end
  end
end
