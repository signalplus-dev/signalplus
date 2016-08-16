import React, { Component } from 'react'
import { DateField } from 'react-date-picker'

export default class Calendar extends Component {
  constructor(props) {
    super(props)
    this.handleChange = this.handleChange.bind(this);
    this.state = {date: this.props.date};
  }

  handleChange(e) {
    const key = 'expirationDate'
    this.setState({date: e});
    this.props.setResponse(key, e);
  }

  render() {
    return (
      <DateField 
        dateFormat="YYYY-MM-DD" 
        defaultValue={this.state.date}
        onChange={this.handleChange}
      />
    );
  }
}
