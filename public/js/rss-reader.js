$(function() {
    setInterval(function () {
        $(".humantime").each(function () {
            var $time = $(this);

            $.get('/humantime', { stamp: this.dataset.stamp }, function(data) {
                $time.text(data)
            });
        });
    }, 90000);
});
