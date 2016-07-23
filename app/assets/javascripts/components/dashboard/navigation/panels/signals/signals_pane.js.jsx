var SignalsPane = React.createClass({
  render: function() {
    return (
      <div>
        <h4 className='signal-header'>{this.renderPanelTitle()}</h4>
        {this.choosePanel()}
        <CreateNew handleClick={this.props.handleClick}/>
      </div>
    );
  },

  renderPanelTitle: function() {
    var signalCount = this.props.signals.length
    if (signalCount == 0) {
      return 'All Signals'
    } else if (signalCount == 1) {
      return 'Signal - 1 Active'
    } else {
      return 'Signals - ' + signalCount + ' Active'
    }
  },

  choosePanel: function() {
    var signalCount = this.props.signals.length

    if (signalCount == 0) {
      return(<WelcomePanel/>)
    } else {
      return(<ActiveSignalPanel signals={this.props.signals}/>)
    }
  }
});
