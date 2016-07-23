var Navigation = React.createClass({
 
  handleTabs: function(tab) {
    var newTabs = this.state.tabList.map(function(t) {
      t.active = false
      return t
    });

    newTabs.push(
      {
        id: newTabs.length + 1,
        name: tab.name,
        paneId: tab.paneId,
        active: true,
      }
    );

    this.setState({tabList: newTabs})
  },

  handleTemplates: function(signalType) {
    this.setState({templateType: signalType})
  },

  handleTabClick: function(tabId) {
    var newTabs = this.state.tabList.map(function(t) {
      t.active = t.id == tabId;
      return t;
    });

    this.setState({ tabList: newTabs });
  },

  getInitialState: function() {
    return {
      tabList: [
        {
          id: 1,
          name: 'SIGNALS',
          paneId: 'signals',
          active: true,
        },
        {
          id: 2,
          name: 'CREATE NEW',
          paneId: 'templates',
          active: false,
        }
      ],

      templateType: ''
    }
  },

  render: function() {
    return (
      <div>
        <Tabs tabs={this.state.tabList} handleClick={this.handleTabClick} />
        <Panes tabs={this.state.tabList} data={this.props.data} handleClick={this.handleTabClick}
        handleTab={this.handleTabs} templateType={this.state.templateType} handleTemplate={this.handleTemplates} />
      </div>
    );
  }
});
