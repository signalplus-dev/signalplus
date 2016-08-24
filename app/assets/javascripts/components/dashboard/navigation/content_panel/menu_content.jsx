import React, { Component } from 'react';
import Edit from './content_panel_views/edit/edit.jsx';
import Promote from './content_panel_views/promote/promote.jsx';
import Preview from './content_panel_views/preview.jsx';
import Activity from './content_panel_views/activity.jsx';


function renderPane(pane, signal) {
  if (pane === 'edit') {
    return <Edit {...{ signal }} />;
  } else if (pane === 'promote') {
    return <Promote {...{ signal }} />;
  } else if (pane === 'preview') {
    return <Preview {...{ signal }} />;
  } else if (pane === 'activity') {
    return <Activity {...{ signal }} />;
  }

  return undefined;
}

function ContentPane({ active, signal, menu }) {
  const pane          = menu.contentId;
  const viewClassName = active ? 'activeTab' : 'inactiveTab';

  return (
    <div className={`content-pane ${viewClassName}`}>
      {renderPane(pane, signal)}
    </div>
  );
}

export default function MenuContent({ menus, signal }) {
  const contentList = menus.map((menu) => {
    return (
      <ContentPane
        active={menu.active}
        key={menu.id}
        {...{ signal, menu }}
      />
    );
  });

  return <div>{contentList}</div>;
}
