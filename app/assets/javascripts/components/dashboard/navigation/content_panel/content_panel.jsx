import React, { Component } from 'react';
import Sidebar from './sidebar.jsx';
import MenuContent from './menu_content.jsx';

export default class ContentPanel extends Component {
  constructor(props) {
    super(props);
    this.handleSideBar = this.handleSideBar.bind(this);
    this.state = {
      sidebarMenus: [
        { id: 1, contentId: 'edit', active: true },
        { id: 2, contentId: 'promote', active: false },
        { id: 3, contentId: 'preview', active: false },
        { id: 4, contentId: 'activity', active: false },
      ],
    };
  }

  handleSideBar(menu) {
    const newMenus = [ ...this.state.sidebarMenus ].map((menuItem) => {
      menuItem.active = menuItem.contentId === menu;
      return menuItem;
    });

    this.setState({ sidebarMenus: newMenus })
  }

  getSignal() {
    if (this.props.editSignal) {
      return ({ edit: this.props.editSignal })
    } else if (this.props.templateType) {
      return ({ type: this.props.templateType })
    }
  }

  render() {
    const signal = this.getSignal();

    return (
      <div className='content-panel'>
          <Sidebar
            menus={this.state.sidebarMenus}
            handleClick={this.handleSideBar}
            signalType={this.signalState}
          />
          <MenuContent
            menus={this.state.sidebarMenus}
            signal={signal}
          />
      </div>
    );
  }
}



