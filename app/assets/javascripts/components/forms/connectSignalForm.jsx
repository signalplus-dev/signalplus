import React, { PureComponent } from 'react';
import { connect } from 'react-redux';
import { reduxForm } from 'redux-form';
import _ from 'lodash';

const genericSignalFormName = 'listenSignalForm';

function getResponses(signal, responses) {
  return _.map(signal.responses, (responseId) => (responses[responseId]));
};

function newSignal(signal, responses) {
  return _.reduce(signal, (currentSignal, value, key) => ({
    ...currentSignal,
    [key]: key === 'responses' ? getResponses(signal, responses) : value,
  }), {});
};

function getSignal(ownProps, state) {
  const { route, params } = ownProps;

  if (route.path === 'new') {
    return {
      type: params.type,
      responses: [{},{}],
    };
  } else {
    const signal = _.get(state, `models.listenSignals.data['${parseInt(params.id)}']`);
    const responses = state.models.responses.data;

    return newSignal(signal, responses);
  }
}

/**
  * Map state to props
  */
const makeMapStateToProps = () => {
  return (state, ownProps) => {
    const signal = getSignal(ownProps, state);
    const formName = `${genericSignalFormName}_${signal.id || signal.type}`;
    const initialValues = {
      ...signal,
      ..._.get(state, `form['${formName}'].values`, {}),
    };

    return {
      formName,
      signal,
      initialValues,
    };
  };
};

/**
  * Allows for dynamically setting signal forms
  *
  * @param {React element} ComposedComponent - an element that should be decorated by redux form
  */
export default function connectSignalForm(ComposedComponent) {
  class Enhanced extends PureComponent {
    componentWillMount() {
      this.form = reduxForm({
        form: this.props.formName,
      })(ComposedComponent);
    }

    render() {
      const Form = this.form;
      return <Form {...this.props} formName={this.props.formName} />;
    }
  }

  return connect(makeMapStateToProps)(Enhanced);
}
