$(document).ready(function() {
    var options = {
        success: function(fragment) {
            $('#comment_list').append(fragment);
            $('form#comment').resetForm();
            $('#comment-count').html( $('#comment_list li').size() )
        }
    };
    $('form#comment').ajaxForm(options);
});