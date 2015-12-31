$(function() {
    $(window).load(resize_images);

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
});

resize_images = function () {
    console.log('Resize Images');

    $(".image-col img").each(function () {
        console.log(this.src);

        var width = this.width;

        if(width > 150) {
            this.width = 150;
        }
    });
}
