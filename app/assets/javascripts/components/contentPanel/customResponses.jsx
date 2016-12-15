import React from 'react';
import { Link } from 'react-router';
import InputBox from 'components/forms/inputBox.jsx';
import _ from 'lodash';

export default function CustomResponses({ responses }) {
  return (
    <li className="uctext">
      <Link
        {...menu.linkProps}
        activeClassName="active"
        className="editMenuItem"
      >
        <label className="signalLabel">
          <span className="caption">SIGNAL NAME</span>
          <InputBox
            name="name"
            placeholder={`Ex. ${_.upperFirst(signal.signal_type)}`}
            componentClass="input"
            className="signalNameInput uctext"
          />
        </label>
        <ActivateSignalRadioButton/>
      </Link>
    </li>
  );
}
