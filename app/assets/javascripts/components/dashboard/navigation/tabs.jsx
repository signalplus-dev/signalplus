import React, { Component } from 'react';

class Tab extends Component {
  constructor(props) {
    super(props);
    this.handleClick = this.handleClick.bind(this);
  }

  handleClick() {
    this.props.handleClick(this.props.tab.id);
  }

  render(){
    var tabClassName = this.props.active ? 'active' : '';

    return (
      <li className={tabClassName} onClick={this.handleClick}>
        <a href={'#'+this.props.tab.paneId} data-toggle='tab'>
          {this.props.tab.name}
        </a>
      </li>
    );
  }
}

export default function Tabs({ tabs, handleClick }) {
  const tabList = tabs.map((tab) => {
    return (
      <Tab
        active={tab.active}
        key={tab.id}
        tab={tab}
        handleClick={handleClick}
      />
    );
  });

  return <ul className='nav nav-tabs'>{tabList}</ul>;
}
