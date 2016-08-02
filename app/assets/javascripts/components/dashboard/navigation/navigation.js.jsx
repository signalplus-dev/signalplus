var Navigation = React.createClass({
  handleTabs: function(tab) {
    var newTabs = [
      {
        id: 1,
        name: 'SIGNALS',
        paneId: 'signals',
        active: false,
      },
      {
        id: 2,
        name: 'CREATE NEW',
        paneId: 'templates',
        active: false,
      }
    ];

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

  handleSignal: function(key, value) {
    var obj = {};
    obj[key] = value;
    this.setState(obj);
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
      signals: this.props.data,
      editSignal: '',
      templateType: ''
    }
  },

  render: function() {
    return (
      <div>
        <Tabs 
          tabs={this.state.tabList} 
          handleClick={this.handleTabClick} 
        />
        <Panes 
          tabs={this.state.tabList} 
          data={this.state.signals} 
          handleClick={this.handleTabClick}
          handleTab={this.handleTabs} 
          handleSignal={this.handleSignal}
          templateType={this.state.templateType} 
          editSignal={this.state.editSignal}
        />
      </div>
    );
  }
});
