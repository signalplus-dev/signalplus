import React from 'react';
import { Link } from 'react-router';
import InputBox from 'components/forms/inputBox';
import ActivateSignalRadioButton from 'components/forms/activateSignalRadioButton';
import _ from 'lodash';

function renderInputBox(signal) {
  return (
    <div>
      <p className="signal-instruction">E
        <span className='signal-instruction-text'>
          nter a signal name to listen for
        </span>
      </p>
      <InputBox
        name="name"
        placeholder="#Name"
        componentClass="input"
        className="signalNameInput uctext"
      />
    </div>
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
          {signal.id ? renderSignalName(signal) : renderInputBox(signal)}
        </label>
        <ActivateSignalRadioButton signal={signal}/>
      </Link>
    </li>
  );
}
