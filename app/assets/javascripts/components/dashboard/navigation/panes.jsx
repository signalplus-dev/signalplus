import React, { Component } from 'react';
import TemplatesPane from './panels/templates/templates_pane.jsx';
import SignalsPane from './panels/signals/signals_pane.jsx';
import ContentPanel from './content_panel/content_panel.jsx'

class PaneContent extends Component {
  renderPane() {
    const pane = this.props.tab.paneId;

    if (pane === 'signals') {
      return (
        <SignalsPane
          handleTab={this.props.handleTab}
          handleClick={this.props.handleClick}
          handleSignal={this.props.handleSignal}
        />
      );
    } else if (pane === 'templates') {
      return (
        <TemplatesPane
          signal_types={this.props.data.signal_types}
          handleTab={this.props.handleTab}
          handleSignal={this.props.handleSignal}
        />
      );
    } else if (pane === 'new') {
      return (
        <ContentPanel
          editSignal={this.props.editSignal}
          templateType={this.props.templateType}
        />
      );
    }
  }

  render() {
    const tabClassName = this.props.active ? 'activeTab' : 'inactiveTab';

    return <div className={`tab-pane dash-panel ${tabClassName}`}>{this.renderPane()}</div>;
  }
}
