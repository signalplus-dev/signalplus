var Edit = React.createClass({
  render: function() {
    return (
      <div className='col-md-9 content-box'>
        <div className='content-header'>
          <SignalIcon type={this.props.signal.type} className='content-icon' />
          <SignalIcon type='explanation' className='content-explanation' />

          <p className='signal-type-label'> TYPE </p>
          <h3 className='signal-type-header'> {this.props.signal.type} Signal </h3>
          <p className='signal-description'> Send your users a special offer everytime they send a custom hashtag </p> 
        </div>
        <hr className='line'/>

        <div className='response-info'>
          <h3>Responses to:</h3>
          <SignalIcon type='twitter'/>
          <h3><strong>@Brand #Offers</strong></h3>
          // <SaveBtn type='add'/>
        </div>

        <div className='tip-box'>
          <SignalIcon type='tip'/>
          <h5>Tip</h5>
          <p> Add your offer responses here, be sure to include a link or details on how to use the offer.  
              When you’re ready, activate your signal and promote it </p>
        </div>

        <div className='response-edit-box'>
          <div className='response-text'>
            <h5>First Response</h5>
            <p>Users will see this response the first time they use your signal</p>
          </div>
          // <InputBox />
        </div>

        <div className='response-edit-box'>
          <div className='response-text'>
            <h5>Not Available/ Repeat Requests</h5>
          </div>
          <InputBox />
        </div>
      </div>
    );
  }
});


var InputBox = React.createClass({
  getInitialState: function() {
    return {
      value: 'Type your response here!'
    };
  },

  handleChange: function(e) {
    this.setState({
      value: e.target.value
    });
  },

  reset: function() {
    this.setState({
      value: ''
    });
  },

  render: function() {
    return (
      <div className='input-box'>
        <button className='glyphicon glyphicon-plus'>
        </button>
        <input value={this.state.value} onChange={this.handleChange} onClick={this.reset} />
      </div>
    );
  }
});

var SaveBtn = React.createClass({
  handleSubmit: function() {
    if (this.props.type = 'add') {
      return null
    } else {
      return null
    }
  },

  render: function() {
    return (
      <button type='button' className='btn btn-primary save-btn' onClick={this.handleSubmit}>
        + ADD
      </button>
    );
  }
});
