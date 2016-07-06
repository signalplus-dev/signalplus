var ShowSignals = React.createClass({
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
  getDefaultProps: function() {
    return {
      signagls: [
        {
          header: 'All Signals',
          panel_header: 'Welcome',
          body: 'Start creating your own signals and responses or use our handy starter guide to learn more'
        }
      ]
    }
  },
  render: function() {
    // var signals= this.props.signals.map(function(signal) {
      return (

        // <div> {console.log(this.props.signals)} </div>

        <div className='panel signal-panel+{this.props.signals}'>
          <h4 className='signal-header'>
            {console.log(this.props.signals)}
          </h4>
        </div>
      );
    // });
  }
});
