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
