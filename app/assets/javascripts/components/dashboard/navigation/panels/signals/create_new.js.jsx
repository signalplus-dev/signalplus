var CreateNew = React.createClass({
  handleClick: function() {
    this.props.handleClick(2);
  },

  render: function() {
    return (
      <a href='#templates'>
        <div onClick={this.handleClick} className='panel signal-panel panel-new'>
          <SignalIcon type='create' />
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
