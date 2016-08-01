var Edit = React.createClass({
  getInitialState: function() {
    var signal = this.props.signal;
    console.log('printing signal')
    console.log(this.props.signal)
    if ('edit' in signal) {
      return {
        signalType: signal['type'],
        name: signal['name'],
        firstResponse: signal['first_response'],
        repeatResponse: signal['repeat_response'],
        active: signal['active'],
        expDate: signal['exp_date']
      };
    } else {
      return {
        signalType: signal.type,
        name: signal.type,
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
          <SignalIcon type={this.props.signal.type} className='content-icon' />
          <SignalIcon type='explanation' className='content-explanation' />

          <p className='signal-type-label'> TYPE </p>
          <h3 className='signal-type-header uctext'> {this.props.signal.type} Signal </h3>
          <p className='signal-description'> Send your users a special offer everytime they send a custom hashtag </p> 
        </div>
        <hr className='line'/>

        <div className='response-info'>
          <h3>Responses to:</h3>
          <SignalIcon type='twitter'/>
          <h3><strong>@Brand #Offers</strong></h3>
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
            <h5>Name/Expiration Date</h5>
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


