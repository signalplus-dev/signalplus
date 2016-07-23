var WelcomePanel = React.createClass({
  render: function() {
    return (
      <div>
        {this.renderPanel()}
      </div>
    );
  },

  renderPanel: function() {
    return (
      <div className='panel signal-panel welcome'>
        <SignalIcon type='welcome' />
        <div className='panel-header'>
          Welcome
        </div>
        <div className='panel-body'>
          Start creating your own signals and responses or use our handy starter guide to learn more
        </div>
      </div>
    );
  }
});
