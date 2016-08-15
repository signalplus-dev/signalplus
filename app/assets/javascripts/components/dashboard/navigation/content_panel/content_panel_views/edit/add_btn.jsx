import React, { Component } from 'react';
import { DropdownButton, MenuItem } from 'react-bootstrap';
import Calendar from './calendar.jsx';

export default class AddBtn extends Component {
  constructor(props) {
    super(props);
  }

  render() {
    return (
      <div className='edit-btns'>
        <DropdownButton title='ADD' className='btn add-btn'>
          <p>Expiration Date</p>
          <Calendar  
            setResponse={this.props.setResponse}
            date={this.props.expirationDate}
          />
        </DropdownButton>
      </div>
    );
  }
}

