import React, { Component } from 'react';
import SignalIcon from '../../../../links/signal_icon.jsx';
import ReactS3Uploader from 'react-s3-uploader';
import {
  Button,
  FormControl,
  Thumbnail,
} from 'react-bootstrap';



export default class Promote extends Component {
  constructor(props) {
    super(props);
    this.handleChange = this.handleChange.bind(this); 
    this.handleSubmit = this.handleSubmit.bind(this);   
    this.state = {
      message: '',
      imageUrl: '',
      imageFile: ''
    };
  }

  handleChange(e) {
    this.setState({message: e.currentTarget.value});
  }

  handleSubmit() {
    this.createPromoTweet(this.state);
  }

  createPromoTweet(data) {
    $.ajax({
      type: 'POST',
      url: '/promo_tweet/create',
      data: data
    }).done((result) => {
      console.log('sucesss');
      console.log(result);
    }).fail((jqXhr) => {
      console.log('failed request');
    });
  }

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
            <FormControl onChange={this.handleChange} componentClass="textarea" placeholder={'Searching for deals any time? Tweet or message #Deals to @Brand'}/>
          </div>

          <div className='subheader'>
            <h5 className='subheader'>Promotional Image</h5>
            <p>Select an image to include or upload your own</p>
          </div>

          <div className='thumbnails'>
            <Thumbnail href="#" alt="171x180" src={this.state.imageUrl} />
            <Thumbnail href="#" alt="171x180" src="/assets/thumbnail.png" />
            <Thumbnail href="#" alt="171x180" src="/assets/thumbnail.png" />
          </div>

          <Button onSubmit={this.handleSubmit} type='submit' className='save-btn post-to-timeline'>POST TO YOUR TIMELINE</Button>


        </div>
      </div>
    );
  }
}
