 var hist = [];
 $(document).ready(function(){
     loadPage('index.html');
 });
 function loadPage(url) {
    $('body').append('<div class="scontainer"><div class="spinner"><div class="bar1"></div><div class="bar2"></div><div class="bar3"></div><div class="bar4"></div><div class="bar5"></div><div class="bar8"></div><div class="bar9"></div><div class="bar10"></div><div class="bar11"></div><div class="bar12"></div></div></div>');
    scrollTo(0,0);
    $('#container').load(url + ' #content', function(){
        var title = $('h1').html() || 'Hello!';
        $('.leftButton').remove();
        hist.unshift({'url':url});
        if (hist.length > 1) {
            $('#header').append('<div class="leftButton">&laquo;</div>');
            $('.leftButton').click(function(e){
                $(e.target).addClass('clicked');
                var thisPage = hist.shift();
                var previousPage = hist.shift();
                loadPage(previousPage.url);
            });
        }
        $('#container a').click(function(e){
            $(e.target).attr("selected", "true");
            var url = e.target.href;
            e.preventDefault();
            loadPage(url);
        });
        $('.scontainer').remove();
    });
}
