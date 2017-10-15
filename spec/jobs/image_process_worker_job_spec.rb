require 'rails_helper'
require 'google/cloud/vision'

RSpec.describe ImageProcessWorkerJob, type: :job do
  let(:task_id) { 657 }
  let(:image_path) { 'tmp/123.png' }

  context 'with mock redis and image labels stub' do
    class ImageProviderStub
      def initialize(image_labels)
        @image_labels = image_labels
      end

      def image(*)
        OpenStruct.new(labels: @image_labels)
      end
    end

    let(:redis_mock) { MockRedis.new }
    let(:google_labels_results) do
      [
        OpenStruct.new(description: 'skyline', score: 0.9754528403282166),
        OpenStruct.new(description: 'city', score: 0.9707457423210144),
        OpenStruct.new(description: 'metropolitan area', score: 0.9481273293495178),
        OpenStruct.new(description: 'other', score: 0.005),
        OpenStruct.new(description: 'dog', score: 0.25123),
        OpenStruct.new(description: 'cat', score: 0.123123)
      ]
    end
    let(:top_google_labels_results) { google_labels_results.sort_by { |elem| elem[:score] }.reverse.first(5) }
    let(:image_provider_stub) { ImageProviderStub.new(google_labels_results) }

    before(:each) do
      allow(Google::Cloud::Vision).to receive(:new).and_return(image_provider_stub)
      allow(Redis).to receive(:new).and_return(redis_mock)
      LabelsAnalytics::Repository.delete(task_id)
    end

    it 'saves top 5 labels into redis (nothing inside redis)' do
      subject.perform(task_id, image_path)
      check_scores(task_id)
      check_counts(task_id)
    end

    it 'updates values in redis' do
      old_values = { skyline: 0.5, city: 0.2 }.stringify_keys
      LabelsAnalytics::Repository.save(task_id, old_values.to_a)
      subject.perform(task_id, image_path)
      check_scores(task_id, old_values)
      check_counts(task_id, old_values)
    end

    xit 'saves all info inside HBASE' do
    end

    xit 'saves image info inside postgres (only path)' do
    end

    def check_scores(task_id, old_values = {})
      expect(LabelsAnalytics::Repository.fetch_scores(task_id)).to eq(expected_scores_result(old_values))
    end

    def check_counts(task_id, old_values = {})
      expect(LabelsAnalytics::Repository.fetch_counts(task_id)).to include(expected_count_results(old_values))
    end

    # :reek:FeatureEnvy
    def expected_scores_result(old_values)
      top_google_labels_results.inject({}) do |hash, elem|
        key = elem[:description]
        hash.merge(key => elem[:score] + old_values[key].to_f)
      end.stringify_keys
    end

    # :reek:FeatureEnvy
    def expected_count_results(old_values)
      top_google_labels_results.map(&:description).inject({}) do |hash, key|
        old_values[key] ? hash.merge(key => '2') : hash.merge(key => '1')
      end
    end
  end
end
