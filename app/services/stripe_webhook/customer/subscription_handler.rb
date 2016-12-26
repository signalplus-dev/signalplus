module StripeWebhook
  module Customer
    class SubscriptionHandler < StripeWebhook::BaseHandler
      def deleted
        unless subscription.deactivated?
          current_time = Time.current
          update_params = { will_be_deactivated_at: current_time }

          unless subscription.canceled_at?
            update_params[:canceled_at] = current_time
          end

          subscription.update!(update_params)
          subscription.brand.turn_off_everything!
        end
      rescue ActiveRecord::RecordNotFound
        # Do nothing; the subscription may have already been destroyed
      end

      private

      def subscription
        @subscription ||= Subscription.find_by!(token: data_object.id)
      end
    end
  end
end
