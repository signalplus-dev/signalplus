var tabList = [
  { 'id': 1, 'name': 'SIGNALS', 'url': '#active' },
  { 'id': 2, 'name': 'CREATE NEW', 'url': '#templates' },
  { 'id': 3, 'name': 'NEW', 'url': '#new' }
];

var Navigation = React.createClass({
  handleClick: function(){
    this.prop.changeTab(tab);
  },

  render: function(){
    return (
      <ul className='nav nav-pills'>
        {tabList.map(function(tab) {
          return (
            <Tab
              url={tab.url}
              name={tab.name}
              key={tab.id}
            />
          );
        })}
      </ul>
    );
  }
});

var Tab = React.createClass({
  handleClick: function(e) {
    e.preventDefault();
    this.prop.handleClick();
  },

  render: function(){
    return (
      <li>
        <a href={this.props.url} data-toggle= 'tab' >
          {this.props.name}
        </a>
      </li>
    );
  }
});


