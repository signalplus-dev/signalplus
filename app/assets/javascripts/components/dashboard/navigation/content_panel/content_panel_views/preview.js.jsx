var Preview = React.createClass({
  render: function() {
    return (
      <div className='col-md-9 content-box'>
        <div className='content-header'>
          <p className='signal-type-label'> REQUEST RESPONSE </p>
        </div>

        <div className='response-info'>
          <SignalIcon type='twitter'/>
          <h3>Public Tweet or Direct Message</h3>
          <SignalIcon type='twitter'/>
          <h3><strong>Direct Message</strong></h3>
        </div>

        <div className='preview-image'>
          <div className='signal-info'>
            {this.props.signal['name']}
          </div>
          <SignalIcon type='public'/>
        </div>

        <div className>
          <div className='preview'>

          </div>
          <div>
          </div>
          <div>
          </div>
        </div>

      </div>
    );
  }
});


