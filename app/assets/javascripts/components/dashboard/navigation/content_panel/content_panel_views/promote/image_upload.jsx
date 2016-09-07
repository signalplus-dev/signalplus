import React, { Component } from 'react';
import Dropzone from 'react-dropzone';
import FileStore from './file_store.js';
import _ from 'lodash';


export default class ImageUpload extends Component {
  constructor(props) {
    super(props);
    this.uploadS3 = this.uploadS3.bind(this);

    this.state = {
      uploadedFile: [],
      uploadedFileUrl: ''
    }
  }

  handleState(key, value) {
    var obj = {};
    obj[key] = value;
    this.setState(obj);
  }

  createResource(file) {
    FileStore.createResource(file, this.props.signal.id);
  }

  uploadS3(files) {
    this.handleState('uploadedFile', files[0]);
    this.createResource(files[0]);
  }

  render() {
    if (_.isEmpty(this.state.uploadedFile)) {
      return (
        <div className='dropzone'>
          <Dropzone
            multiple={true}
            accept='image/*'
            onDrop={this.uploadS3}>
            <div className='dropzone-text'>Drag & Drop an image to upload!</div>
          </Dropzone>
        </div>
      );
    } 

    return (
      <img src={this.state.uploadedFile.preview}/>
    );
  }
};
