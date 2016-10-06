import React, { Component } from 'react';
import { connect } from 'react-redux';
import _ from 'lodash';
import PromoteImage from 'components/contentPanel/promoteImage.jsx';
import SignalIcon from 'components/links/signal_icon.jsx';
import { addPromotionalTweetData } from 'redux/modules/models/promotionalTweets.js';
import {
  Button,
  FormControl,
} from 'react-bootstrap';

class Promote extends Component {
  constructor(props) {
    super(props);
    this.handleChange   = this.handleChange.bind(this);
    this.handleImage    = this.handleImage.bind(this);
    this.handleEncoding = this.handleEncoding.bind(this);
    this.handleSubmit   = this.handleSubmit.bind(this);

    this.state = {
      listen_signal_id: this.props.params.id,
      message: '',
      image: '',
      encoded_image: '',
    }
  }

  handleChange(e) {
    this.setState({ message: e.currentTarget.value });
  }

  handleImage(image, encodedImage) {
    this.setState({ image: image });
  }

  handleEncoding(encodedImage) {
    this.setState({ encoded_image: encodedImage });
  }

  handleSubmit() {
    const { dispatch } = this.props;
    dispatch(addPromotionalTweetData(this.state));
  }

  render() {
    const { signal } = this.props;

    if (signal.id) {
      return (
        <div className='col-xs-9 content-box'>
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
            <div className='subheader'>
              <h5>Promotional Tweet</h5>
              <p>140 Character Limit</p>
            </div>
            <div className='promote-input-box'>
              <FormControl onChange={this.handleChange} componentClass="textarea" placeholder={'Searching for deals any time? Tweet or message #Deals to @Brand'}/>
            </div>
            <div className='subheader'>
              <h5>Promotional Image</h5>
              <p>Select an image to include or upload your own</p>
            </div>
            <div className='row'>
              <div className='col-xs-12 col-sm-12 col-md-12 col-lg-12 center promote-image'>
                <PromoteImage image={this.state.image} handleImage={this.handleImage} handleEncoding={this.handleEncoding}/>
              </div>
            </div>
            <Button onClick={this.handleSubmit} className='save-btn post-to-timeline-btn'>POST TO YOUR TIMELINE</Button>
          </div>
        </div>
      );
    } else {
      return (
        <div className='create-signal-warning'> Please create signal first to create a promotional tweet </div>
      );
    }
  }
}

export default connect()(Promote);
