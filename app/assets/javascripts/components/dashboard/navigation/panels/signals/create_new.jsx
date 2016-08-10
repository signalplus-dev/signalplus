import React, { Component } from 'react';
import SignalIcon from '../../../../links/signal_icon.jsx';

export default class CreateNew extends Component {
  constructor(props) {
    super(props);
    this.handleClick = this.handleClick.bind(this);
  }

  handleClick() {
    this.props.handleClick(2);
  }

  render() {
    return (
      <a href='#templates'>
        <div onClick={this.handleClick} className='panel signal-panel panel-new'>
          <SignalIcon type='create' className='panel-icon'/>
          <div className='panel-header header-new'>
            Create New
          </div>
          <div className='panel-body body-new'>
            Click here to create a new signal for your audience
          </div>
        </div>
      </a>
    );
  }
}
