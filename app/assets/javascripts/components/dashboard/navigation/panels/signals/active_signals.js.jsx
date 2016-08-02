var ActiveSignalPanel = React.createClass({
  render: function() {
    return (
      <div>
        {this.renderPanel()}
      </div>
    );
  },

  handleClick: function(idx, signalType) {
    tab = {
      name: 'Edit',
      className: 'active',
      paneId: 'new'
    };
    
    this.props.handleTab(tab);
    this.props.handleSignal('editSignal', this.props.signals[idx]);
  },

  renderPanel: function() {
    var scope = this;
    signals = [];

    this.props.signals.forEach(function(s, idx) {
      signals.push(
        <div onClick={scope.handleClick.bind(this, idx)} className={'panel signal-panel '+ s.signal_type} key={idx} >
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
            <p>TYPE</p>
            <span className='uctext type'>{s.signal_type}</span>
          </div>
        </div>
      );
    }, this);
    return signals
  }
});