# Public: Repository to save/fetch info about labels for particular task
# Information is stored in Redis hash: keys are labels and values are scores
#
module LabelsAnalytics
  class Repository
    class << self
      # Public: saves info about labels for particular task or raises default DB errors
      #
      # tag_search_id - Integer. Task identifier
      # labels - 2d Array. Labels data to store. Ex [ ['sky', 0.5], ['ocean', 0.3] ]
      #
      # Examples
      #
      #   save(1456, [ ['sky', 0.5], ['ocean', 0.3] ])
      #   # => true
      #
      def save(tag_search_id, labels)
        labels.each do |label, score|
          db_store.pipelined do
            db_store.hincrbyfloat(task_key_scores(tag_search_id), label, score)
            db_store.hincrbyfloat(task_key_counts(tag_search_id), label, 1)
          end
        end
        true
      end

      def fetch_scores(tag_search_id)
        prepare_scores_result(db_store.hgetall(task_key_scores(tag_search_id)))
      end

      def fetch_counts(tag_search_id)
        db_store.hgetall(task_key_counts(tag_search_id))
      end

      def delete(tag_search_id)
        db_store.del([task_key_scores(tag_search_id), task_key_counts(tag_search_id)])
      end

      private

      def prepare_scores_result(data)
        Hash[*data.map { |key, val| [key, val.to_f] }.sort_by { |_key, val| -val }.flatten]
      end

      def task_key_scores(tag_search_id)
        "task_#{tag_search_id}_label_scores"
      end

      def task_key_counts(tag_search_id)
        "task_#{tag_search_id}_label_counts"
      end

      def db_store
        @db_store ||= Redis.new(url: ENV['REDIS_DATA_STORE_URL'])
      end
    end
  end
end
