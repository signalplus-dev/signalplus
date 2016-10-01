import React, { Component } from 'react';
import Dropzone from 'react-dropzone';
import _ from 'lodash';


export default class ImageUpload extends Component {
  constructor(props) {
    super(props);
    this.onDrop = this.handleDrop.bind(this);
  }

  handleDrop(files) {
    this.props.handleImage(files[0]);
  }

  render() {
    if (_.isEmpty(this.props.image)) {
      return (
        <div className='dropzone'>
          <Dropzone
            accept='image/*'
            style={{ width: 300, height: 200 }}
            onDrop={this.onDrop}>

            <div className='dropzone-text'>Upload image...</div>
          </Dropzone>
        </div>
      );
    }

    return (
      <img src={this.props.image.preview}/>
    );
  }
}
