var Edit = React.createClass({
  getInitialState: function() {
    if (this.props.signal['edit']) {
      var signal = this.props.signal['edit'];
      var responses = signal['responses'];
      return {
        signalType: signal['signal_type'],
        name: signal['name'],
        firstResponse: responses[0]['message'],
        repeatResponse: responses[1]['message'],
        active: signal['active'],
        expDate: signal['exp_date']
      };
    } else if (this.props.signal['type']) {
      var signal = this.props.signal['type'];
      
      return {
        signalType: signal,
        name: signal,
        firstResponse: 'Type your response here',
        repeatResponse: 'Type your response here',
        active: false,
        expDate: '2017-01-01'
      }; 
    }
  },

  setResponse: function(key, value) {
    var obj = {};
    obj[key] = value;
    this.setState(obj);
  },

  render: function() {
    return (
      <div className='col-md-9 content-box'>
        <div className='content-header'>
          <SignalIcon type={this.state.signalType} className='content-icon' />
          <SignalIcon type='explanation' className='content-explanation' />
          <p className='signal-type-label'> TYPE </p>
          <h3 className='signal-type-header uctext'> {this.state.signalType} Signal </h3>
          <p className='signal-description'> 
            Send your users a special offer everytime they send a custom hashtag 
          </p> 
        </div>

        <hr className='line'/>

        <div className='response-info'>
          <h4>Responses to:</h4>
          <SignalIcon type='twitter'/>
          <h4 className='subheading'>@Brand #{this.state.name}</h4>
          <SaveBtn type='add' data={{ 'listen_signal': this.state }}/>
        </div>

        <div className='tip-box'>
          <SignalIcon type='tip'/>
          <h5>Tip</h5>
          <p> Add your offer responses here, be sure to include a link or details on how to use the offer.  
              When you’re ready, activate your signal and promote it </p>
        </div>

        <div className='response-edit-box'>
          <div className='response-text'>
            <h5>Name</h5>
            <br/>
            <h5>Expiration Date</h5>
          </div>
          <InputBox data={this.state.name} setResponse={this.setResponse} type='name'/>
        </div>

        <div className='response-edit-box'>
          <div className='response-text'>
            <h5>First Response</h5>
            <p>Users will see this response the first time they use your signal</p>
          </div>
          <InputBox data={this.state.firstResponse} setResponse={this.setResponse} type='firstResponse'/>
        </div>

        <div className='response-edit-box'>
          <div className='response-text'>
            <h5>Not Available/ Repeat Requests</h5>
          </div>
          <InputBox data={this.state.repeatResponse} setResponse={this.setResponse} type='repeatResponse'/>
        </div>
      </div>
    );
  }
});


