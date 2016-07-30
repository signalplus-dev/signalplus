var Promote = React.createClass({
  render: function() {
    var FormControl = ReactBootstrap.FormControl;
    var Grid = ReactBootstrap.Grid;
    var Row = ReactBootstrap.Row;
    var Col = ReactBootstrap.Col;
    var Thumbnail = ReactBootstrap.Thumbnail;


    return (
      <div className='col-md-9 content-box'>
        <div className='content-header'>
          <p className='signal-type-label'> SEND TWEET </p>
        </div>

        <div className='response-info'>
          <h3>Promote to:</h3>
          <SignalIcon type='twitter'/>
          <h3><strong>@Brand #Offers</strong></h3>
        </div>

        <div className='tip-box'>
          <SignalIcon type='tip'/>
          <h5>Tip</h5>
          <p> Increase the awareness of your signal, promote it to your audience </p>
        </div>

        <div className='promote-box'>
          <div className='response-text'>
            <h5>Promotional Tweet</h5>
            <p>140 Character Limit</p>
          </div>

          <div className='input-box'>
            <FormControl type="text" placeholder='Searching for deals any time? Tweet or message #Deals to @Brand' />
          </div>

          <div className='subheader'>
            <h5 className='subheader'>Promotional Image</h5>
            <p>Select an image to include or upload your own</p>
          </div>

          <div className='thumbnails'>
            <Grid>
              <Row>
              <Col xs={6} md={2}>
                <Thumbnail href="#" alt="171x180" src="/assets/thumbnail.png" />
              </Col>
              <Col xs={6} md={2}>
                <Thumbnail href="#" alt="171x180" src="/assets/thumbnail.png" />
              </Col>
              <Col xs={6} md={2}>
                <Thumbnail href="#" alt="171x180" src="/assets/thumbnail.png" />
              </Col>
              </Row>
            </Grid>
          </div>
        </div>
      </div>
    );
  }
});
