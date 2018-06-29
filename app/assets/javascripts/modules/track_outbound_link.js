$(function () {
  $('*[data-module="track-outbound-link"]').each(
    function (i, element) {
      $(element).click(function() {
        var url = $(element).attr('href');
        gtag('event', 'click', {
          'event_category': 'outbound',
          'event_label': url
        });
        return true;
      })
    }
  )
})
