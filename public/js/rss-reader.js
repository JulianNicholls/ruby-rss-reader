$(function() {
    setInterval(function () {
        $(".humantime").each(function () {
            var $time = $(this);

            $.get('/humantime', { stamp: this.dataset.stamp }, function(data) {
                $time.text(data)
            });
        });
    }, 90000);

    $("select#feeds").on('change', function () {
        window.location = '/feed/' + this.value;
    });

    $("#reload").on('click', function () {
      window.location.reload(true);
    });
});
