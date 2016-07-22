var CreateNew = React.createClass({
  render: function() {
    return (
      <a href='#templates' data-toggle='tab'>
        <div className='panel signal-panel panel-new'>
          <SignalIcon path='icons/signalplus-small' />
          <div className='panel-header header-new'>
            Create New
          </div>
          <div className='panel-body body-new'>
            Click here to create a new signal for your audience
          </div>
        </div>
      </a>
    );
  }
});
