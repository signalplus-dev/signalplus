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
