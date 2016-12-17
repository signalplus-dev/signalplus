const genericSignalFormName = 'listenSignalForm';

export function getFormNameFromSignal(signal) {
  return `${genericSignalFormName}_${signal.id || signal.signal_type}`;
}
