let handle = setInterval(updateTimestamps, 90000);

function updateTimestamps() {
  let first = true;

  $(".humantime").each(function () {
    var $time = $(this);

    $.get('/humantime', { stamp: this.dataset.stamp, first: first }, function(data) {
      data = JSON.parse(data);
      if (data.first && data.ago.match(/yesterday/i)) {
        console.log('Cancelling update')
        clearInterval(handle);    // Stop asking after the top one is yesterday
      }

      $time.text(data.ago)
    });

    first = false;
  });
}

$(function() {
  $("select#feeds").on('change', function () {
    window.location = '/feed/' + this.value;
  });

  $("#reload").on('click', function () {
    window.location.reload(true);
  });
});
