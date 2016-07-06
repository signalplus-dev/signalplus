var Navigation = React.createClass({
  getDefaultProps: function() {
    return {
      tabList: [
        {
          id: 1,
          name: 'SIGNALS',
          className: 'active',
          paneId: 'signals'
        },
        {
          id: 2,
          name: 'CREATE NEW',
          className: '',
          paneId: 'templates'
        },
        {
          id: 3,
          name: 'NEW',
          className: '',
          paneId: 'new'
        }
      ]
    }
  },
  render: function() {
    return (
      <div>
        <Tabs data={this.props.tabList} />
        <Panes data={this.props.tabList} />
      </div>
    );
  }
});

var Tabs = React.createClass({
  render: function() {
    var tabList = this.props.data.map(function(tab) {
      return (
        <Tab key={tab.id} data={tab} />
      );
    });
    return (
      <ul className='nav nav-tabs'>
        {tabList}
      </ul>
    );
  }
});

var Tab = React.createClass({
  render: function(){
    return (
      <li role='presentation' className={this.props.data.className}>
        <a href={'#'+this.props.data.paneId} data-toggle='tab'>
          {this.props.data.name}
        </a>
      </li>
    );
  }
});

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
      <div role='tabpanel' className={"tab-pane "+this.props.data.className} id={this.props.data.paneId}>
        {this.render_pane()}
      </div>
    );
  },
  render_pane: function() {
    var pane = this.props.data.paneId;

    if ( pane == 'signals') {
      return (<ShowSignals/>)
    } else if ( pane == 'templates') {
      return (<SignalTemplates />)
    } else if ( pane == 'new') {
      return (<NewSignal />)
    }
  }
});


