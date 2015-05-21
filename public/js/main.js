$(function() {
  $('.add-star').click(function(){
    var $this = $(this);
    var post_id = $this.attr('data-post-id');

    $.ajax({
      url:'/star?post_id=' + post_id,
      success: function(data){
        //
        // num=$("#"+post_id).text();
        // num++;
        // $("#"+post_id).html(num);


        //要素を追加する li
        //var newElement = document.createElement('li');
        var $newElement = $("<li>");
        //liの中のテキスト要素（★）
        $newElement.text('○');

        var $parentElement = $this.parent();

        var $ulElement = $parentElement.children('ul.star-container');
        $ulElement.append($newElement);


        },
        error: function(data){
          alert ('失敗しちゃったよ><');
        }
      }
    );

  });
});
