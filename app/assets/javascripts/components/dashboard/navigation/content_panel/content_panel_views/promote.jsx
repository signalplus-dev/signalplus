import React, { Component } from 'react';
import SignalIcon from '../../../../links/signal_icon.jsx';
import {
  FormControl,
  Grid,
  Row,
  Col,
  Thumbnail,
} from 'react-bootstrap';

export default class Promote extends Component {
  render() {
    return (
      <div className='col-md-9 content-box'>
        <div className='content-header'>
          <p className='signal-type-label'> SEND TWEET </p>
        </div>

        <div className='response-info'>
          <h4>Promote:</h4>
          <SignalIcon type='twitter'/>
          <h4 className='subheading'>@Brand #Offers</h4>
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
            <FormControl componentClass="textarea" placeholder={'Searching for deals any time? Tweet or message #Deals to @Brand'}/>
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
}
