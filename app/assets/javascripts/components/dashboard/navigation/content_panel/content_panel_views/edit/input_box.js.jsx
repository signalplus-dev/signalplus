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
    var FormControl = ReactBootstrap.FormControl;

    return (
      <div className='input-box'>
        <FormControl type="text" placeholder={this.props.data} onClick={this.reset}/>
      </div>
    );
  }
});

