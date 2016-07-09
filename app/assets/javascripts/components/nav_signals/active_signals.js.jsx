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
        <div className={'panel signal-panel '+ s.signal_type}>
          <SignalIcon path={'icons/' + s.signal_type} />
          <div className='panel-header'>
            {'# ' + s.name}
          </div>
          <div className='panel-body'>
            Send your users a special offer every time they send a custom hashtag
          </div>
          <div className='panel-status'>
            <div className='signal-status'>
              <div className='circle active'>
                <span className='status'>ACTIVE</span>
              </div>
            </div>
          </div>
          <div className='signal-type uctext'>
            {s.signal_type}
          </div>
        </div>
      );
    });
    return signals
  }
});
