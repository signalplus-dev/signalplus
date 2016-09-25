import React, { Component } from 'react';
import { FormControl } from 'react-bootstrap';

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
    const { componentClass } = this.props;

    return (
      <div className='input-box'>
        <FormControl
          componentClass={componentClass}
          onChange={this.handleChange}
          placeholder={placeholder}
          className={this.props.className}
        />
      </div>
    );
  }
}

