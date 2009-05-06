$(document).ready(function() {
  var options = { 
    url: '/comments',
    success: function(fragment) {
               $('#comment_list').append(fragment);
               $('form#comment').resetForm();
             }
  };
  $('form#comment').ajaxForm(options);
});