var Edit = React.createClass({
  getInitialState: function() {
    return {
      signalType: this.props.signal.type,
      firstResponse: 'Type your response here',
      firstUrl: '',
      repeatResponse: 'Type your response here',
      repeatlink: '',
      active: false
      startDate: '',
      endDate: ''
    };
  },

  setResponse: function(key, value) {
    var obj = {};
    obj[key] = value;
    this.setState(obj);
  },

  handleBtnClick:function() {

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
          <SaveBtn type='add' data={this.state}/>
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
          <InputBox response={this.state.firstResponse} setResponse={this.setResponse} type='first'/>
        </div>

        <div className='response-edit-box'>
          <div className='response-text'>
            <h5>Not Available/ Repeat Requests</h5>
          </div>
          <InputBox response={this.state.repeatResponse} setResponse={this.setResponse} type='repeat'/>
        </div>
      </div>
    );
  }
});


