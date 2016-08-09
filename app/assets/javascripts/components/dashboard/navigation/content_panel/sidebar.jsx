import React, { Component } from 'react';

class MenuItem extends Component {
  constructor(props) {
    super(props);
    this.handleClick = this.handleClick.bind(this);
  }

  handleClick() {
    this.props.handleClick(this.props.menu.contentId);
  }

  renderMenuItem(menu) {
    return <a href={`#${menu}`}>{menu}</a>;
  }

  render() {
    const menuClassName = this.props.active ? 'active' : '';
    const menu = this.props.menu.contentId;

    return (
      <li className={`${menuClassName} ${menu}`} onClick={this.handleClick}>
        {this.renderMenuItem(menu)}
      </li>
    );
  }
}

export default function Sidebar({ menus, handleClick }) {
  const sidebarMenus = menus.map((menu) => {
    return <MenuItem active={menu.active} key={menu.id} {...{ menu, handleClick }} />;
  });

  return (
    <div className='col-md-2 sidebar'>
      <ul className='sidebar-menus'>
        {sidebarMenus}
      </ul>
    </div>
  );
}
