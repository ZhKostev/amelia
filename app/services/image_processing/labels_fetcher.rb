require 'google/cloud/vision'

module ImageProcessing
  class LabelsFetcher
    def initialize(image_path)
      @image_path = image_path
    end

    def labels_with_scores
      @labels_with_scores ||= image.labels.map do |label_data|
        { label: label_data.description, score: label_data.score }
      end
    end

    private

    def image
      @image ||= image_provider.image(@image_path)
    end

    def image_provider
      @image_provider ||= Google::Cloud::Vision.new
    end
  end
end
