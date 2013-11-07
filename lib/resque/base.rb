module Resque
  module Base
    def self.included(base)
      base.extend(ClassMethods)
    end
    module ClassMethods
      def queue
        :q
      end

      def create(id: -1, args: {})
        Resque.enqueue(self, id, args[0])
        Task.find(id).queued
      end

      # def enqueue(klass, args)
      #   queue = Resque.queue_from_class(klass) || queue
      #   Resque.enqueue_to(queue, klass, @task.id, args)
      # end

      def perform(id = -1, args = {})
        task = Task.find(id)
        instance = new
        instance.safe_perform!(id, args)
        instance
      end
    end

    def safe_perform!(id, args = {})
      @task = Task.find(id)
      @task.in_progress
      perform(args)
      @task.succeeded
    rescue => e
      log(e.message)
      log(Rails.backtrace_cleaner.clean(e.backtrace).to_s.gsub(',', "\n"))
      @task.failed
    end

    def log(msg)
      @task.log(msg)
    end
  end
end