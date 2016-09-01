import React, { Component } from 'react';
import ReactS3Uploader from 'react-s3-uploader';
import Dropzone from 'react-dropzone';
import FileStore from './file_store.js';
import _ from 'lodash';


export default class ImageUpload extends Component {
  constructor(props) {
    super(props);
    this.uploadS3 = this.uploadS3.bind(this);
    this.showImage = this.showImage.bind(this);
    this.state = {
      uploadedFile: [],
      ulloadedFileUrl: ''
    }
  }

  createResource(file) {
    FileStore.createResource(file, this.props.signal.id);
  }

  setImageState(file) {
    this.setState({
      uploadedFile: file
    });
  }

  uploadS3(files) {
    this.setImageState(files[0]);
    this.createResource(files[0]);
  }

  showImage() {
    return (
      <div>
        <img src={this.state.uploadedFile.preview}/>
      </div>
    );
  }

  showDropzone() {
    return (
      <Dropzone
        multiple={true}
        accept='image/*'
        onDrop={this.uploadS3}>
        <div>Drop an image!</div>
      </Dropzone>
    );
  }

  render() {
    if (_.isEmpty(this.state.uploadedFile)) {
      return this.showDropzone();
    } 
    return (this.showImage());

  }
};
