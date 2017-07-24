class ImageProcessWorkerJob < ApplicationJob
  queue_as :default

  def perform(image_path)
    puts ImageProcessing::LabelsFetcher.new(image_path).labels_with_scores
  end
end
