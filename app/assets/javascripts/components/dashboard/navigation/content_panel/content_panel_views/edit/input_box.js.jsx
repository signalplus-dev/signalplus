var InputBox = React.createClass({

  handleChange: function(e) {
    key = this.props.type;
    this.props.setResponse(key, e.target.value);
  },

  reset: function(e) {
    if (this.props.data == 'Type your response here') {
      key = this.props.type;
      this.props.setResponse(key, '');
    };
  },

  render: function() {
    return (
      <div className='input-box'>
        <input value={this.props.data} onChange={this.handleChange} onClick={this.reset} />
      </div>
    );
  }
});

