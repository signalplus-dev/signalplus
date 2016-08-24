export default const FileStore = {} {

  API_PATH_PREFIX = '/api/v1';

  getResources() {
    return $.ajax({
      url:      API_PATH_PREFIX + '/promotional_tweets',
      type:     'GET',
      dataType: 'json'
    });
  };

  // 1. Generate signed upload URL
  // 2. Upload to s3
  // 3. Post uploaded file properties to API
  // var createResource = function(file, callbacks) {
  //   return getSignedUploadUrl(file)
  //   .then(function(data) {
  //     return uploadFile(file, data.upload.url, data.upload.content_type, callbacks);
  //   })
  //   .then(function(downloadUrl) {
  //     return saveResource(file, downloadUrl, callbacks);
  //   });
  // };

  createResource(file) {
    return getSignedUploadUrl(file)
    .then(function(data) {
      return uploadFile(file, data.upload.url, data.upload.content_type);
    })
    .then(function(downloadUrl) {
      return saveResource(file, downloadUrl);
    });
  };

  getSignedUploadUrl(file) {
    return $.ajax({
      url:      API_PATH_PREFIX + '/uploads',
      type:     'POST',
      dataType: 'json',
      data: {
        upload: { image_filename: file.name }
      }
    });
  };

  uploadFile(file, uploadUrl, contentType, callbacks) {
    var deferred = $.Deferred();

    var xhr = new XMLHttpRequest();
    xhr.open('PUT', uploadUrl, true);
    xhr.setRequestHeader('Content-Type', contentType);

    xhr.onload = function() {
      if (xhr.status === 200) {
        callbacks.onProgress(file, file.size);
        deferred.resolve(uploadUrl.split('?')[0]);
      } else {
        deferred.reject(xhr);
      }
    };

    xhr.onerror() {
      deferred.reject(xhr);
    };

    xhr.upload.onprogress(e) {
      if (e.lengthComputable) {
        callbacks.onProgress(file, e.loaded);
      }
    };

    xhr.send(file);

    return deferred.promise();
  };

  saveResource(file, downloadUrl, callbacks) {
    return $.ajax({
      url:      API_PATH_PREFIX + '/promotional_tweets',
      type:     'POST',
      dataType: 'json',
      data: {
        document: {
          direct_upload_url:   downloadUrl,
          upload_file_name:    file.name,
          upload_content_type: file.type,
          upload_file_size:    file.size
        }
      }
    });
  };

  return {
    getResources:   getResources,
    createResource: createResource
  };

}
