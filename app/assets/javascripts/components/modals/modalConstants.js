// Components
import DeleteSignalModal from 'components/modals/deleteSignalModal';
import CancelSubscriptionModal from 'components/modals/cancelSubscriptionModal';
import ToggleSignalModal from 'components/modals/toggleSignalModal';

export const DELETE_SIGNAL = 'DELETE_SIGNAL';
export const CANCEL_SUBSCRIPTION = 'CANCEL_SUBSCRIPTION';
export const TOGGLE_SIGNAL = 'TOGGLE_SIGNAL';

export const MODAL_COMPONENTS = {
  DELETE_SIGNAL: DeleteSignalModal,
  CANCEL_SUBSCRIPTION: CancelSubscriptionModal,
  TOGGLE_SIGNAL: ToggleSignalModal,
}
