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
      <div className='sidebar-wrapper'>
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

    return (
      <li className={menuClassName} onClick={this.handleClick}> 
        <a href={'#'+this.props.menu.contentId}>
          {this.props.menu.contentId}
        </a>
      </li>
    );
  }
});

        // <div className='signal-info'>
        //   <p>SIGNAL NAME</p>
        //   <p>{'#' + this.signalType}</p>
        //   <a href='#'>Edit Name</a>
        // </div>
        // <div className='promote'>
        //   <h4>Promote</h4>
        // </div>
        // <div className='preview'>
        //   <h4>Preview</h4>
        // </div>
        // <div className='activity'>
        //   <h4>Activity</h4>
        // </div>
        // <div className='signal-delete'>
        //   <a href='#'>DELETE SIGNAL</a>
        // </div>
