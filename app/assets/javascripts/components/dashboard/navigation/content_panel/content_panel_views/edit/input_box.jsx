import React, { Component } from 'react';
import { FormControl } from 'react-bootstrap';

export default class InputBox extends Component {
  constructor(props) {
    super(props);
    this.handleChange = this.handleChange.bind(this);
    this.reset        = this.reset.bind(this);

    if (props.componentClass) {
      this.state = { componentClass: props.componentClass };
    } else {
      this.state = { componentClass: 'textarea'}
    }
  }

  handleChange(e) {
    var key = this.props.type;
    this.props.setResponse(key, e.target.value);
  }

  reset(e) {
    if (this.props.data === 'Type your response here') {
      var key = this.props.type;
      this.props.setResponse(key, '');
    };
  }

  render() {
    return (
      <div className='input-box'>
        <FormControl
          componentClass={this.state.componentClass}
          onChange={this.handleChange}
          placeholder={this.props.data}
          onClick={this.reset}
          className={this.props.className}
        />
      </div>
    );
  }
}

