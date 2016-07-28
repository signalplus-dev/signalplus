var InputBox = React.createClass({
  getInitialState: function() {
    return {
      value: 'Type your response here!'
    };
  },

  handleChange: function(e) {
    this.setState({
      value: e.target.value
    });
  },

  reset: function() {
    this.setState({
      value: ''
    });
  },

  render: function() {
    return (
      <div className='input-box'>
        <button className='glyphicon glyphicon-plus'>
        </button>
        <input value={this.state.value} onChange={this.handleChange} onClick={this.reset} />
      </div>
    );
  }
});

