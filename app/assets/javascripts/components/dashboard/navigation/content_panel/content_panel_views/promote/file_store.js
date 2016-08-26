const API_PATH_PREFIX = '/api/v1';

const getSignedUploadUrl = (file) => {
  return $.ajax({
    url:      API_PATH_PREFIX + '/uploads',
    type:     'GET',
    dataType: 'json',
    data: {
      upload: { filename: file.name }
    }
  });
};

const uploadFile = (file, uploadUrl, contentType) => {
  var deferred = $.Deferred();

  var xhr = new XMLHttpRequest();
  xhr.open('PUT', uploadUrl, true);
  xhr.setRequestHeader('Content-Type', contentType);
  
  xhr.onload = () => {
    if (xhr.status === 200) {
      // callbacks.onProgress(file, file.size);
      deferred.resolve(uploadUrl.split('?')[0]);
    } else {
      deferred.reject(xhr);
    }
  };

  xhr.onerror = () => {
    deferred.reject(xhr);
  };

  xhr.upload.onprogress = (e) => {
    if (e.lengthComputable) {
      // callbacks.onProgress(file, e.loaded);
    }
  };

  xhr.send(file);

  return deferred.promise();
};

const saveResource = (file, downloadUrl) => {
  return $.ajax({
    url:      API_PATH_PREFIX + '/promotional_tweets',
    type:     'POST',
    dataType: 'json',
    data: {
      promotional_tweet: {
        direct_upload_url:  downloadUrl,
        image_file_name:    file.name,
        image_content_type: file.type,
        image_file_size:    file.size
      }
    }
  });
};

const FileStore = {
  getResources: function() {
    return $.ajax({
      url:      API_PATH_PREFIX + '/promotional_tweets',
      type:     'GET',
      dataType: 'json'
    });
  },

  // 1. Generate signed upload URL
  // 2. Upload to s3
  // 3. Post uploaded file properties to API
  createResource: function(file) {
    return getSignedUploadUrl(file)
      .then(function(data) {
        return uploadFile(file, data.url, data.content_type);
      })
      .then(function(downloadUrl) {
        return saveResource(file, downloadUrl);
      });
  },
}

export default FileStore;
