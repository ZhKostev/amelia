require 'spec_helper'
require_relative '../../../app/services/image_processing/labels_fetcher'

describe ImageProcessing::LabelsFetcher do
  context 'with test image' do
    let(:test_fetcher) { described_class.new("#{Dir.pwd}/spec/fixtures/images/perth.jpg") }
    let(:expected_result) do
      [
        { label: 'skyline', score: 0.9754528403282166 },
        { label: 'city', score: 0.9707457423210144 },
        { label: 'metropolitan area', score: 0.9481273293495178 }
      ]
    end

    before(:each) do
      google_results = [
        OpenStruct.new(description: 'skyline', score: 0.9754528403282166),
        OpenStruct.new(description: 'city', score: 0.9707457423210144),
        OpenStruct.new(description: 'metropolitan area', score: 0.9481273293495178)
      ]
      expect_any_instance_of(Google::Cloud::Vision::Image)
        .to receive(:labels).exactly(1).times.and_return(google_results)
    end

    it 'returns valid labels for image' do
      expect(test_fetcher.labels_with_scores).to match_array(expected_result)
    end

    it 'uses memoization for results' do
      test_fetcher.labels_with_scores
      test_fetcher.instance_variable_set('@image_path', 'other_value')
      test_fetcher.instance_variable_set('@image', nil)
      expect(test_fetcher.labels_with_scores).to eq(expected_result)
    end
  end
end
