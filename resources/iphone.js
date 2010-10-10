 var hist = [];
 $(document).ready(function(){
     loadPage('index.html');
 });
 function loadPage(url) {
    $('body').append('<div id="progress">Loading...</div>');
    scrollTo(0,0);
    $('#container').load(url + ' #content', function(){
        var title = $('h1').html() || 'Hello!';
        $('.leftButton').remove();
        hist.unshift({'url':url});
        if (hist.length > 1) {
            $('#header').append('<div class="leftButton">&laquo;</div>');
            $('#header .leftButton').click(function(){
                var thisPage = hist.shift();
                var previousPage = hist.shift();
                loadPage(previousPage.url);
            });
        }
        $('#container a').click(function(e){
            var url = e.target.href;
            e.preventDefault();
            loadPage(url);
        });
        $('#progress').remove();
    });
}
