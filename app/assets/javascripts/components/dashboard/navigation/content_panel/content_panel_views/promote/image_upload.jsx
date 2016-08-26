import React, { Component } from 'react';
import ReactS3Uploader from 'react-s3-uploader';
import Dropzone from 'react-dropzone';
import FileStore from './file_store.js';

export default class ImageUpload extends Component {
  constructor(props) {
    super(props);
    this.uploadS3 = this.uploadS3.bind(this);
    this.state = {
      uploadedFile: null,
      ulloadedFileUrl: ''
    }
  }

  createResource(file) {
    FileStore.createResource(file);
  }

  uploadS3(files) {
    console.log('uploading to s3')

    this.setState({ 
      uploadedFile: files[0]
    });
    
    this.createResource(this.state.uploadedFile);
  }

  render() {
    return (
      <Dropzone
        multiple={true}
        accept='image/*'
        onDrop={this.uploadS3}>
        <div>Drop an image!</div>
      </Dropzone>
    );
  }
};
