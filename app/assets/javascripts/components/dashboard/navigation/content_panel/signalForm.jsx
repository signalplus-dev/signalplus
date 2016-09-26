import React, { Component } from 'react';
import { connect } from 'react-redux';
import { reduxForm } from 'redux-form';
import _ from 'lodash';

const genericSignalFormName = 'listenSignalForm';

class UndecoratedSignalForm extends Component {
  constructor(props) {
    super(props);
    this.updateSignal = this.updateSignal.bind(this);
  }

  updateSignal(form) {
    console.log(form);
  }

  render() {
    const {
      children,
      handleSubmit,
    } = this.props;

    return (
      <form className='content-panel' onSubmit={handleSubmit(this.updateSignal)}>
        {children}
      </form>
    );
  }
}

class SignalForm extends Component {
  constructor(props) {
    super(props);
    this.state = { transitioning: false };
  }

  createForm(formName) {
    this.form = reduxForm({
      form: formName,
    })(UndecoratedSignalForm);
  }

  componentWillMount() {
    this.createForm(this.props.formName);
  }

  componentWillUpdate(nextProps, nextState) {
    this.createForm(nextProps.formName);
  }

  componentWillReceiveProps(nextProps) {
    this.setState({
      transitioning: nextProps.currentRoute !== this.props.currentRoute,
    });
  }

  shouldComponentUpdate(nextProps, nextState) {
    return (
      this.state.transitioning ||
      nextProps.formName !== this.props.formName
    );
  }

  render() {
    const { signal, initialValues, ...props } = this.props;
    const Form = this.form;
    return (
      <Form {...{ ...props, signal, initialValues }} />
    );
  }
}

export default connect((state, ownProps) => {
  const formName = `${genericSignalFormName}_${ownProps.signal.id || ownProps.signal.signal_type}`;

  return {
    formName,
    currentRoute: state.routing.locationBeforeTransitions.pathname,
    initialValues: {
      ...ownProps.signal,
      ..._.get(state, `app.dashboard.tabs.['${formName}']`, {}),
    },
  };
})(SignalForm);
