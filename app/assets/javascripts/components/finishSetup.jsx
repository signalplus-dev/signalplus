import React, { PureComponent } from 'react';
import { reduxForm } from 'redux-form';
import { browserHistory } from 'react-router';
import { provideHooks } from 'redial';

import Checkbox from 'components/forms/checkbox';
import TimezoneDropdown from 'components/forms/timezoneDropdown';

import { required, timezoneValidator, createValidator } from 'components/forms/validations';
import { updateUserInfo, getUserData } from 'redux/modules/models/user';
import jstz from 'jstimezonedetect';

const hooks = {
  fetch: ({ dispatch }) => (dispatch(getUserData())),
};

const form = 'finishSetup';

class FinishSetup extends PureComponent {
  constructor(props) {
    super(props);
    this.finishSetup = this.finishSetup.bind(this);
  }

  finishSetup({ tz, accepted_terms_of_use, ...user }) {
    const { dispatch } = this.props;
    dispatch(updateUserInfo({ user, brand: { tz, accepted_terms_of_use } }))
      .then(() => browserHistory.push('/dashboard'));
  }

  render() {
    const { handleSubmit } = this.props;
    return (
      <form onSubmit={handleSubmit(this.finishSetup)}>
        <div className="main">
          <div className="container-fluid">
            <div className="row">
              <div className="col-xs-12 page">
                <div className="pageHeader">
                  <h1>Welcome to SignalPlus</h1>
                  <p>
                    We just need a couple additional items:
                  </p>
                </div>
                <div className="finishSetupSection">
                  <div className="finishSetupForm">
                    <div className="finishSetupFormField">
                      <Checkbox
                        name="accepted_terms_of_use"
                        className="finishSetupCheckbox"
                        label="Terms of Use"
                        labelDescription={
                          <span>I agree to SignalPlus' <a>Terms of Use</a></span>
                        }
                      />
                    </div>
                    <div className="finishSetupFormField">
                      <Checkbox
                        name="email_subscription"
                        className="finishSetupCheckbox"
                        label="Emails from SignalPlus"
                        labelDescription="Please send me updates on new features and announcements"
                      />
                    </div>
                    <div className="finishSetupFormField">
                      <div><strong>Time Zone</strong></div>
                      <div className="bigCaption timezoneLabel">
                        Set a default time zone for your account.
                        This will determine timing for your responses.
                      </div>
                      <TimezoneDropdown
                        name="tz"
                        componentClass="input"
                      />
                    </div>
                    <button className="btn select-btn fullWidth">
                      CONTINUE TO DASHBOARD
                    </button>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </form>
    );
  }
}

const validate = createValidator({
  accepted_terms_of_use: required,
  tz: timezoneValidator,
});

const Form = reduxForm({
  form,
  validate,
  initialValues: {
    accepted_terms_of_use: true,
    email_subscription: true,
    tz: jstz.determine().name(),
  },
})(FinishSetup);

export default provideHooks(hooks)(Form);
