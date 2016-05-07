class UpdateTrackerWorker
  include Sidekiq::Worker

  sidekiq_options :retry => false

  def perform(tracker_id, tracker_class, message_ids)
    tracker_class_const = Kernel.const_get(tracker_class)
    timeline_tracker    = tracker_class_const.find(tracker_id)
    TimelineHelper.update_tracker!(timeline_tracker, message_ids)
  end
end
