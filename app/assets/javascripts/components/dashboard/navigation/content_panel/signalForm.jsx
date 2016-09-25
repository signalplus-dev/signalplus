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

  shouldComponentUpdate(nextProps, nextState) {
    return nextProps.formName !== this.props.formName;
  }

  render() {
    const { signal, children, initialValues } = this.props;
    const Form = this.form;
    return (
      <Form {...{ signal, initialValues }} >
        {children}
      </Form>
    );
  }
}

export default connect((state, ownProps) => {
  const formName = `${genericSignalFormName}_${ownProps.signal.id || ownProps.signal.type}`;

  return {
    formName,
    initialValues: {
      ...ownProps.signal,
      ..._.get(state, `form['${formName}'].values`, {}),
    },
  };
})(SignalForm);
