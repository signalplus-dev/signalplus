var SaveBtn = React.createClass({
  handleSubmit: function() {
    this.createSignal(this.props.data);
  },

  createSignal: function(data) {
    $.ajax({
      type: 'POST',
      url: '/template/signal',
      data: data
    })
    .done(function(result) {
      console.log('success' + result)

    }.bind(this))
    .fail(function(jqXhr) {
      console.log('failed to register');
    });
  },

  render: function() {
    return (
      <div className='edit-btns'>
        <button type='button' className='btn btn-primary save-btn' onClick={this.handleSubmit}>
          SAVE
        </button>
      </div>
    );
  }
});
