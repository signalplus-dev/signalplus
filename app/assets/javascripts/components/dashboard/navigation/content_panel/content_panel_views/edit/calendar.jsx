import React, { Component } from 'react'
import { DateField } from 'react-date-picker'

export default class Calendar extends Component {
  constructor(props) {
    super(props)
    this.handleChange = this.handleChange.bind(this);
  }

  handleChange(e) {
    console.log(e.target.value);
  }

  render() {
    return (
      <DateField dateFormat="YYYY-MM-DD" onChange={this.handleChange}/>
    );
  }
}
