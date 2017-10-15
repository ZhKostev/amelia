require 'rails_helper'

describe SearchLimitChecker do
  context 'with redis stub' do

    let(:mock_redis) { MockRedis.new }

    before(:each) do
      allow(described_class).to receive(:store).and_return(mock_redis)
      allow(described_class).to receive(:daily_limit).and_return(2)
    end

    describe '.limit_is_reached?' do

      it 'returns false if nothing inside redis' do
        expect(described_class.limit_is_reached?).to eq(false)
      end

      it 'returns false if limit is not reached' do
        set_value_in_redis(1)
        expect(described_class.limit_is_reached?).to eq(false)
      end

      it 'returns true is limit is reached' do
        set_value_in_redis(2)
        expect(described_class.limit_is_reached?).to eq(true)
      end
    end

    describe '.search_is_performed' do
      it 'sets redis key to 1 for first search' do
        check_value_in_redis(nil)
        described_class.search_is_performed
        check_value_in_redis('1')
      end

      it 'increments redis key by 1 if some searches were already performed' do
        set_value_in_redis(4)
        described_class.search_is_performed
        check_value_in_redis('5')
      end
    end

    def set_value_in_redis(value)
      mock_redis.set(Time.zone.today.strftime('search_count_%d_%m_%y'), value)
    end

    def check_value_in_redis(value)
      expect( mock_redis.get(Time.zone.today.strftime('search_count_%d_%m_%y'))).to eq(value)
    end
  end
end