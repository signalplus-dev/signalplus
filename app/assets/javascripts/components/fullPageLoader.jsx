import React from 'react';
import { connect } from 'react-redux';
import cn from 'classnames';
import Loader from 'components/loader';

function FullPageLoader({ loading }) {
  const classes = cn({
    fullPageLoader: true,
    show: loading,
  });

  return (
    <div className={classes}>
      <Loader/>
    </div>
  );
}

export default connect(state => ({
  loading: state.app.loading,
}))(FullPageLoader);
