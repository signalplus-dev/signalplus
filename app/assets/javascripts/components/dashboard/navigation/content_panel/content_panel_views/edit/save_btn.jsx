import React, { Component } from 'react';

export default class SaveBtn extends Component {
  constructor(props) {
    super(props);
    this.handleSubmit = this.handleSubmit.bind(this);
  }

  handleSubmit() {
    this.createSignal(this.props.data);
  }

  createSignal(data) {
    $.ajax({
      type: 'POST',
      url: '/template/signal',
      data: data
    }).done((result) => {
      // Need to update the highest level signal state.
      console.log('success' + result)
    }).fail((jqXhr) => {
      console.log('failed to register');
    });
  }

  render() {
    return (
      <div className='edit-btns'>
        <button
          type='button'
          className='btn btn-primary save-btn'
          onClick={this.handleSubmit}
        >
          SAVE
        </button>
      </div>
    );
  }
}
