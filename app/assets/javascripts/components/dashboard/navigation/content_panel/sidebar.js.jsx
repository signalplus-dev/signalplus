var Sidebar = React.createClass({
  render: function() {
    var self = this;
    var sidebarMenus = this.props.menus.map(function(menu) {
      return ( 
        <MenuItem
          active={menu.active}
          key={menu.id}
          menu={menu}
          handleClick={self.props.handleClick}
        />
      );
    });
    return (
      <div className='col-md-2 sidebar'>
        <ul className='sidebar-menus'>
          {sidebarMenus}
        </ul>
      </div>
    );
  }
});


var MenuItem = React.createClass({
  handleClick: function() {
    this.props.handleClick(this.props.menu.contentId);
  },

  render: function() {
    var menuClassName = this.props.active ? 'active' : '';
    var menu = this.props.menu.contentId;

    return (
      <li className={menuClassName + ' ' + menu} onClick={this.handleClick}> 
        {this.renderMenuItem(menu)} 
      </li>
    );
  },

  renderMenuItem: function(menu) {
    if (menu == 'edit') {
      return (<a href={'#' + menu}>{menu}</a>);
    } else if (menu == 'activity') {
      return ( <a href={'#' + menu}>{menu}</a>);
    } else {
      return(<a href={'#' + menu}>{menu}</a>);
    }
  }
});


