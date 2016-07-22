var Tabs = React.createClass({
  render: function() {
    var self = this;
    var tabList = this.props.tabs.map(function(tab) {
      console.log(self.props.handleClick);
      return (
        <Tab
          active={tab.active}
          key={tab.id}
          tab={tab}
          handleClick={self.props.handleClick}
        />
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
  handleClick: function() {
    this.props.handleClick(this.props.tab.id);
  },

  render: function(){
    var tabClassName = this.props.active ? 'active' : '';

    return (
      <li className={tabClassName} onClick={this.handleClick}>
        <a href={'#'+this.props.tab.paneId} data-toggle='tab'>
          {this.props.tab.name}
        </a>
      </li>
    );
  }
});
