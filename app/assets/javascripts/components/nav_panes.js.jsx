var Panes = React.createClass({
  render: function() {
    var paneList = this.props.data.map(function(pane) {
      return (
        <PaneContent key={pane.id} data={pane} />
      );
    });
    return (
      <div className='tab-content clearfix'>
        {paneList}
      </div>
    );
  }
});

var PaneContent = React.createClass({
  render: function() {
    return (
      <div role='tabpanel' className={"tab-pane dash-panel "+this.props.data.className} id={this.props.data.paneId}>
        
        {this.renderPane()}
      </div>
    );
  },

  renderPane: function() {
    var pane = this.props.data.paneId;

    if ( pane == 'signals') {
      return (<GetSignals/>)
    } else if ( pane == 'templates') {
      return (<SignalTemplates />)
    } else if ( pane == 'new') {
      return (<NewSignal />)
    }
  }
});
