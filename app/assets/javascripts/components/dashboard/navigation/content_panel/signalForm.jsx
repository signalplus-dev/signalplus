import React, { Component } from 'react';
import { connect } from 'react-redux';
import { reduxForm } from 'redux-form';
import { browserHistory } from 'react-router';
import _ from 'lodash';
import { actions as appActions } from '../../../../redux/modules/app.js';
import { addListenSignalData, updateListenSignalData } from '../../../../redux/modules/models/listenSignals.js';
import { createTab } from './content_panel.jsx';


const genericSignalFormName = 'listenSignalForm';

class UndecoratedSignalForm extends Component {
  constructor(props) {
    super(props);
    this.updateSignal = this.updateSignal.bind(this);
  }

  updateSignal({id, ...form}) {
    const { dispatch, tabId } = this.props;
    if (id) {
      dispatch(updateListenSignalData(form, id));
    } else {
      dispatch(addListenSignalData(form)).then((response) => {
        const { tabId } = this.props;
        const listenSignal = _.get(response, 'payload.listen_signal');
        const newTab = createTab(listenSignal);
        dispatch(appActions.replaceTab({ tabId, newTab }));
        browserHistory.push(`/dashboard/signals/${listenSignal.id}`)
      });
    }
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

export const RESPONSE_TYPES = {
  DEFAULT: 'default',
  REPEAT: 'repeat',
};

const EDITABLE_SIGNAL_FIELDS = [
  'id',
  'name',
  'active',
  'signal_type',
  'expiration_date',
];

const findType = (type) => (response) => {
  return _.get(response, 'response_type') === type;
};

function getResponseMessage(responses, type) {
  return _.get(_.find(responses, findType(type)), 'message');
}

function normalizeSignalForEdit(signal) {
  const responses = _.get(signal, 'responses', []);

  return {
    ..._.pick(signal, EDITABLE_SIGNAL_FIELDS),
    [`${RESPONSE_TYPES.DEFAULT}_response`]: getResponseMessage(responses, RESPONSE_TYPES.DEFAULT),
    [`${RESPONSE_TYPES.REPEAT}_response`]: getResponseMessage(responses, RESPONSE_TYPES.REPEAT),
    responses: _.drop(responses, 2),
  };
};

export default connect((state, ownProps) => {
  const formName = `${genericSignalFormName}_${ownProps.signal.id || ownProps.signal.signal_type}`;

  return {
    formName,
    currentRoute: state.routing.locationBeforeTransitions.pathname,
    initialValues: {
      ...normalizeSignalForEdit(ownProps.signal),
      ..._.get(state, `app.dashboard.tabs.['${formName}']`, {}),
    },
  };
})(SignalForm);
