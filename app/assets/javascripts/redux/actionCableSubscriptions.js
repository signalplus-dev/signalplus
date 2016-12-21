import { createAction } from 'redux-actions';
import getActionCable from 'util/actionCable';
import _ from 'lodash';

const BASE_DISPATCH_ACTION_TYPE = '@@actionCable/RECEIVE_CHANNEL_DATA';

export const subscribedChannels = {
  MONTHLY_RESPONSE_COUNT_CHANNEL: 'MonthlyResponseCountChannel',
};

export function getChannelActionType(channelName) {
  return `${BASE_DISPATCH_ACTION_TYPE}/${channelName}`
}

/**
  * Creates an ActionCable channel subscription that dispatches redux actions that can be acted upon
  * within the redux store.
  *
  * @param {object} channelInfo - An object that defines the channel. Should at the very least contain
  *                               a channel key. The rest of the attributes will be passed to the redux
  *                               action as meta properties.
  * @param {function} dispatch - the redux dispatch function
  */
function createReduxSubscription(channelInfo, dispatch) {
  const { channel, ...meta } = channelInfo;
  const actionCable = getActionCable();

  const dispatchAction = createAction(
    getChannelActionType(channel),
    (data) => data,
    () => meta
  );

  actionCable.subscriptions.create(channelInfo, {
    received: data => dispatch(dispatchAction(data)),
  });
}

/**
  * @return {Array} An array of channel subscriptions
  */
export function createChannelSubscriptions(config = {}) {
  return [
    {
      channel: 'MonthlyResponseCountChannel',
      brand_id: config.brand_id,
    },
  ];
}

export function subscribeToChannels(channelSubscriptions, dispatch) {
  _.each(channelSubscriptions, channelInfo => {
    createReduxSubscription(channelInfo, dispatch);
  });
}
