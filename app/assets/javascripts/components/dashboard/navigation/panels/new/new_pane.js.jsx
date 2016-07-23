var NewPane = React.createClass({
  render: function() {
    return (
      <ContentPanel signalType={this.props.templateType}/>
    );
  }
});

