var Panes = React.createClass({
  render: function() {
    var paneList = this.props.tabs.map(function(pane) {
      return (
        <PaneContent active={pane.active} key={pane.id} tab={pane} data={this.props.data} handleTab={this.props.handleTab} />
      );
    }, this);
    return (
      <div className='tab-content clearfix'>
        {paneList}
      </div>
    );
  }
});

var PaneContent = React.createClass({
  render: function() {
    var tabClassName = this.props.active ? 'activeTab' : 'inactiveTab';

    return (
      <div className={"tab-pane dash-panel " + tabClassName}>
        
        {this.renderPane()}
      </div>
    );
  },

  renderPane: function() {
    var pane = this.props.tab.paneId;
    if ( pane == 'signals') {
      return (<SignalsPane signals={this.props.data.signals} />)
    } else if ( pane == 'templates') {
      return (<TemplatesPane signal_types={this.props.data.signal_types} handleTab={this.props.handleTab} />)
    } else if ( pane == 'new') {
      return (<NewPane/>)
    }
  },
});
