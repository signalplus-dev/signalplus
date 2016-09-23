import React, { Component } from 'react';
import { FormControl, FormGroup } from 'react-bootstrap';

export default class InputBox extends Component {
  constructor(props) {
    super(props);
    this.handleChange = this.handleChange.bind(this);
  }

  handleChange(e) {
    var key = this.props.type;
    this.state = { value: e.target.value };
    this.props.setResponse(key, e.target.value);
  }

  render() {
    const placeholder = this.props.data ? this.props.data : this.props.placeholder;
    
    return (
      <div className='input-box'>
        <FormControl
          componentClass={this.props.componentClass}
          onChange={this.handleChange}
          placeholder={placeholder}
          className={this.props.className}
        />
      </div>
    );
  }
}

