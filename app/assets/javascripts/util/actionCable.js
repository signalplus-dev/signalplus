let actionCable;

export default function getActionCable() {
  if (actionCable) return actionCable;

  if (window && window.ActionCable){
    actionCable = window.ActionCable.createConsumer(process.env.ACTION_CABLE_URL);

    return actionCable;
  }

  return {};
};
