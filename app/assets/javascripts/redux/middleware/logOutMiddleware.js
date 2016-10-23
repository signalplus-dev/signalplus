export default store => next => (action) => {
  if (action.payload && action.payload.constructor.name === 'ApiError') {
    if (action.payload.status === 401) {
      document.getElementById('js_logOutLink').click();
    }
  }

  return next(action);
}
