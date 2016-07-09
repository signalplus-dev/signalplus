var GetSignals = React.createClass({
  getSignals: function() {
    $.ajax({
      url: '/dashboard/get_data',
      dataType: 'json',
      success: function(data) {
        this.setState({signals: data});
      }.bind(this),
      error: function(xhr, status, err) {
        console.error('/dashboard/get_data', status, err.toString());
      }.bind(this)
    });
  },
  getInitialState: function() {
    return {signals: []};
  },
  componentDidMount: function() {
    this.getSignals();
  },
  render: function() {
    return (
      <div>
        <SignalPanel signals={this.state.signals} />
      </div>
    );
  }
});

var SignalPanel = React.createClass({
  render: function() {
    return (
      <div>
        <h4 className='signal-header'>{this.renderPanelTitle()}</h4>
        {this.choosePanel()}
        <CreateNew/>
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
