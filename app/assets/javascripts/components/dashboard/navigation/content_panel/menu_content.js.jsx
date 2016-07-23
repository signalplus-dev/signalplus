var MenuContent = React.createClass({
  render: function() {
    var contentList = this.props.menus.map(function(menu) {
      return (
        <ContentPane active={menu.active} key={menu.id} menu={menu}
          signalState={this.props.signalState} />
      );
    }, this);

    return (
      <div className='container-fluid'>
        <div className = 'row'>
          {contentList}
        </div>
      </div>
    );
  }
});

var ContentPane = React.createClass({
  render: function() {
    var viewClassName = this.props.active ? 'activeTab' : 'inactiveTab';
    return (
      <div className={'col-md-12 content-pane ' + viewClassName}>
        {this.renderPane()}
      </div>
    );
  },

  renderPane: function() {
    var pane = this.props.menu.contentId;

    if (pane == 'edit') {
      return (<Edit/>)
    } else if (pane == 'promote') {
      return (<Promote/>)
    } else if (pane == 'preview') {
      return (<Preview/>)
    } else if (pane == 'activity') {
      return (<Activity/>)
    }
  }
});
