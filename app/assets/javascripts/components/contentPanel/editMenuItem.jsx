import React from 'react';
import { Link } from 'react-router';
import InputBox from 'components/forms/inputBox';
import ActivateSignalRadioButton from 'components/forms/activateSignalRadioButton';
import _ from 'lodash';

function renderInputBox(signal) {
  return (
    <InputBox
      name="name"
      placeholder="#Name"
      componentClass="input"
      className="signalNameInput uctext"
    />
  );
}

function renderSignalName(signal) {
  return <div>{`#${signal.name}`}</div>;
}

export default function EditMenuItem({ menu, signal }) {
  return (
    <li className="uctext">
      <Link
        {...menu.linkProps}
        activeClassName="active"
        className="editMenuItem"
      >
        <label className="signalLabel">
          <span className="caption">SIGNAL NAME</span>
          <p className="caption">Enter a signal name to listen for</p>
          {signal.id ? renderSignalName(signal) : renderInputBox(signal)}
        </label>
        <ActivateSignalRadioButton signal={signal}/>
      </Link>
    </li>
  );
}
