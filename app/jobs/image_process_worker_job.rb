class ImageProcessWorkerJob < ApplicationJob
  DEFAULT_TOP_LABELS_LIMIT = 5
  queue_as :default

  def perform(tag_search_id, image_path)
    labels_data = prepared_labels_data(ImageProcessing::LabelsFetcher.new(image_path).labels_with_scores)
    LabelsAnalytics::Repository.save(tag_search_id, labels_data)
    broadcast_data(tag_search_id, image_path, labels_data)
  end

  private

  # :reek:UtilityFunction
  def broadcast_data(tag_search_id, image_path, labels_data)
    ActionCable.server.broadcast(
      TagSearchChannel.stream_name(tag_search_id),
      data: { image_path: image_path, labels: labels_data }
    )
  end

  # :reek:FeatureEnvy
  def prepared_labels_data(data)
    data.sort_by { |elem| -elem[:score].to_f }.first(labels_limit).map { |info| [info[:label], info[:score]] }
  end

  # :reek:UtilityFunction
  def labels_limit
    ENV['TOP_LABELS_SAVE_LIMIT'] || DEFAULT_TOP_LABELS_LIMIT
  end
end
