var ApiUtil = {
  fetchPosts: function() {
    $.ajax({
      url: '/promotional_tweet',
      type: 'GET',
      dataType: 'json',
      success: function(promotional_tweet) {
        PostActions.receivePosts(promotional_tweet);
      }
    });
  },

  fetchPost: function(id) {
    $.ajax({
      url: '/api/posts/' + id,
      type: 'GET',
      dataType: 'json',
      success: function(post) {
        PostActions.receivePost(post);
      }
    });
  },

  createPost: function(formData, callback) {
    $.ajax({
      url: '/api/posts',
      type: 'POST',
      processData: false,
      contentType: false,
      dataType: 'json',
      data: formData,
      success: function(post) {
        PostActions.receivePost(post);
        callback && callback();
      }
    })
  }
};
