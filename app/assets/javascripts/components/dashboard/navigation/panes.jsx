import React, { Component } from 'react';
import TemplatesPane from './panels/templates/templates_pane.jsx';
import SignalsPane from './panels/signals/signals_pane.jsx';
import NewPane from './panels/new/new_pane.jsx';

class PaneContent extends Component {
  renderPane() {
    const pane = this.props.tab.paneId;
    if ( pane === 'signals') {
      return <SignalsPane signals={this.props.data.signals} />;
    } else if ( pane == 'templates') {
      return <TemplatesPane signal_types={this.props.data.signal_types} handleTab={this.props.handleTab} />;
    } else if ( pane == 'new') {
      return <NewPane/>;
    }
  }

  render() {
    const tabClassName = this.props.active ? 'activeTab' : 'inactiveTab';

    return (
      <div className={"tab-pane dash-panel " + tabClassName}>
        {this.renderPane()}
      </div>
    );
  }
}

export default function Panes({
  tabs,
  data,
  handleTab,
}) {
  const paneList = tabs.map((pane) => {
    return (
      <PaneContent active={pane.active} key={pane.id} tab={pane} data={data} handleTab={handleTab} />
    );
  });

  return (
    <div className='tab-content clearfix'>
      {paneList}
    </div>
  );
}
