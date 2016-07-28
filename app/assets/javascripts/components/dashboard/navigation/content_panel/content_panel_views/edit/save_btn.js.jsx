var SaveBtn = React.createClass({
  handleSubmit: function() {
    if (this.props.type = 'add') {
      return null
    } else {
      return null
    }
  },

  render: function() {
    return (
      <button type='button' className='btn btn-primary save-btn' onClick={this.handleSubmit}>
        + ADD
      </button>
    );
  }
});
