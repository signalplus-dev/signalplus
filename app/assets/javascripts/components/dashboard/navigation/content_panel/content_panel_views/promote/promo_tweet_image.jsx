import React, { Component } from 'react';
import FileStore from './file_store.js';

export default class PromoteTweetImage extends Component {
  constructor(props) {
    this.state = { images: [] };
  }

  componentDidMount() {
    FileStore.getResources()
    .then(function(data) {
      this.setState({ images: data.images });
    }.bind(this));
  }

  handleCreateDocument(document) {
    this.setState({ documents: $.merge([document], this.state.documents) });
  },

}
