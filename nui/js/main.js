window.addEventListener('message', (event) => {
    if (event.data.type === 'open') {
        $('.notification-title').html(event.data.title);
        $('.notification-description').html(event.data.description);
        $('.notification-message p').html(event.data.message);
        $(".notification-box").css({
            'display': 'none'
        }).animate({
            opacity: "1.0"
        }, 1e3, function () {
            $(".notification-box").css({
                'display': 'block'
            })
        })
    } else if (event.data.type === 'close') {
        $(".notification-box").css({
            'display': 'block'
        }).animate({
            opacity: "0"
        }, 1e3, function () {
            $(".notification-box").css({
                'display': 'none'
            })
        })
    } else if (event.data.type === 'update') {
        $('.notification-title').html(event.data.title);
        $('.notification-description').html(event.data.description);
        $('.notification-message p').html(event.data.message);
    }
});