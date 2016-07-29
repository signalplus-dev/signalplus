var InputBox = React.createClass({

  handleChange: function(e) {
    key = this.props.type + 'Response';
    this.props.setResponse(key, e.target.value);
  },

  reset: function(e) {
    if (this.props.response == 'Type your response here') {
      key = this.props.type + 'Response';
      this.props.setResponse(key, '');
    };
  },

  render: function() {
    var DropdownButton = ReactBootstrap.DropdownButton;
    var MenuItem = ReactBootstrap.MenuItem;

    return (
      <div className='input-box'>
        <input value={this.props.response} onChange={this.handleChange} onClick={this.reset} />
      </div>
    );
  }
});

