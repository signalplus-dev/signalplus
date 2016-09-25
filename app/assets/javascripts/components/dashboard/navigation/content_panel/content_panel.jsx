import React, { Component } from 'react';
import { connect } from 'react-redux';
import { provideHooks } from 'redial';
import _ from 'lodash';
import Sidebar from './sidebar.jsx';
import MenuContent from './menu_content.jsx';
import { actions as appActions } from '../../../../redux/modules/app.js';
import { getListenSignalData } from '../../../../redux/modules/models/listenSignals.js';
import SignalForm from './signalForm.jsx';

const EXISTING_SIGNAL_PATHNAME_REGEX = /^\/dashboard\/signals\/\d+/;

function isExistingSignal(pathname) {
  return EXISTING_SIGNAL_PATHNAME_REGEX.test(pathname);
}

function getResponses(signal, responses) {
  return _.map(signal.responses, (responseId) => (responses[responseId]));
};

function newSignal(signal, responses) {
  return _.reduce(signal, (currentSignal, value, key) => ({
    ...currentSignal,
    [key]: key === 'responses' ? getResponses(signal, responses) : value,
  }), {});
};

function getSignal(state, ownProps) {
  const { location, params } = ownProps;

  if (isExistingSignal(location.pathname)) {
    const signal = _.get(state, `models.listenSignals.data['${parseInt(params.id)}']`);
    const responses = state.models.responses.data;

    return newSignal(signal, responses);
  }

  return {
    signal_type: params.type,
    responses: [{},{}],
  };
}

const hooks = {
  fetch: ({ dispatch, location, params }) => {
    if (isExistingSignal(location.pathname)) {
      const id = parseInt(params.id);
      dispatch(getListenSignalData(id));
    }
  },
};

class ContentPanel extends Component {
  constructor(props) {
    super(props);
    this.handleSideBar = this.handleSideBar.bind(this);
    this.updateSignal = this.updateSignal.bind(this);
    this.state = {
      sidebarMenus: [
        { id: 1, contentId: 'edit', active: true },
        { id: 2, contentId: 'promote', active: false },
        { id: 3, contentId: 'preview', active: false },
        { id: 4, contentId: 'activity', active: false },
      ],
    };
  }

  updateSignal(form) {
    console.log(form);
  }

  createTab(signal) {
    const { signal_type: type, id, name } = signal;
    const isNew = !id

    return {
      id: isNew ? `new_${type}_${_.uniqueId()}` : `existing_${id}`,
      label: isNew ? `New ${_.upperFirst(type)} Signal` : `#${_.upperFirst(name)}`,
      link: isNew ? `/dashboard/signals/new/${type}` : `/dashboard/signals/${id}`,
      closeable: true,
    }
  }

  shouldCreateTab(signal) {

    const { location, tabs } = this.props;
    if (!isExistingSignal(location.pathname)) return true;

    return !!signal.id
  }

  componentWillMount() {
    const { signal, tabs, dispatch } = this.props;

    if (this.shouldCreateTab(signal)) {
      dispatch(appActions.addTab(this.createTab(signal)));
      this.setState({ tabCreated: true });
    }
  }

  componenWillReceiveProps({ signal, dispatch }) {
    if (this.shouldCreateTab(signal, tabs)) {
      dispatch(appActions.addTab(this.createTab(signal)));
      this.setState({ tabCreated: true });
    }
  }

  handleSideBar(menu) {
    const newMenus = [ ...this.state.sidebarMenus ].map((menuItem) => {
      menuItem.active = menuItem.contentId === menu;
      return menuItem;
    });

    this.setState({ sidebarMenus: newMenus })
  }

  render() {
    const { signal, routeProps } = this.props;

    return (
      <SignalForm signal={signal}>
        <Sidebar
          menus={this.state.sidebarMenus}
          handleClick={this.handleSideBar}
          signalType={this.signalState}
        />
        <MenuContent
          menus={this.state.sidebarMenus}
          signal={signal}
        />
      </SignalForm>
    );
  }
}

const ConnectedContentPanel = connect((state, ownProps) => ({
  signal: getSignal(state, ownProps),
  tabs: state.app.dashboard.tabs,
}))(ContentPanel);

export default provideHooks(hooks)(ConnectedContentPanel);

