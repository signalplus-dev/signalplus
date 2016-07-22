var TemplatesPane = React.createClass({
  render: function() {
    return (
      <div>
        <h3> Create New Signal </h3>
        <p> Select a template to start </p>
        <div className='create-new'>
          {this.renderTemplates()}
        </div>
      </div>
    );
  },

  handleClick: function(idx, signal_type) {
    tab = {
      name: 'NEW',
      className: 'active',
      paneId: 'new'
    };

    this.props.handleTab(tab);
  },

  renderTemplates: function() {
    var scope = this;
    templates = [];

    this.props.signal_types.forEach(function(t, idx) {
      templates.push(
        <div onClick={scope.handleClick.bind(this, idx, t.type)} key={idx} className='panel signal-panel panel-new'>
          <SignalIcon type={t.type} />
          <div className={'panel-header ' + t.type}>
            <div className='header-text uctext'>
              {t.type}
            </div>
            <div className='subheader'>
              SIGNAL
            </div>
          </div>
          <div className='panel-body'>
            {t.text}
          </div>
        </div>
      );
    }, this);
    return templates
  }
});
