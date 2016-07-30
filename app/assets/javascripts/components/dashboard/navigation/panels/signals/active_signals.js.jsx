var ActiveSignalPanel = React.createClass({
  render: function() {
    return (
      <div>
        {this.renderPanel()}
      </div>
    );
  },

  renderPanel: function() {
    signals = [];
    this.props.signals.forEach(function(s, idx) {
      signals.push(
        <div className={'panel signal-panel '+ s.signal_type} key={idx} >
          <SignalIcon type={s.signal_type} className='panel-icon'/>
          <div className='panel-header'>
            {'# ' + s.name}
          </div>
          <div className='panel-body'>
            Send your users a special offer every time they send a custom hashtag
          </div>
          <div className='panel-status'>
            <div className='signal-status'>
              <div className='circle active'></div>
              <span className='status'>ACTIVE</span>

            </div>
          </div>
          <div className='signal-type'>
            <span>TYPE</span>
            {s.signal_type}
          </div>
        </div>
      );
    });
    return signals
  }
});
