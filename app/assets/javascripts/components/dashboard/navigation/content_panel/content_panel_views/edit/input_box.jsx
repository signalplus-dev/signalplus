import React, { Component } from 'react';
import { FormControl } from 'react-bootstrap';

export default class InputBox extends Component {
  constructor(props) {
    super(props);
    this.handleChange = this.handleChange.bind(this);
    this.reset        = this.reset.bind(this);
  }

  handleChange(e) {
    const key = this.props.type;
    this.props.setResponse(key, e.target.value);
  }

  reset(e) {
    if (this.props.data === 'Type your response here') {
      const key = this.props.type;
      this.props.setResponse(key, '');
    };
  }

  render() {
    return (
      <div className='input-box'>
        <FormControl
          componentClass="textarea"
          onChange={this.handleChange}
          placeholder={this.props.data}
          onClick={this.reset}
        />
      </div>
    );
  }
}

