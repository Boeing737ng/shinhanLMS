const PAGE_COUNT = 3;
const SESSION_TIME = 30;
var currentTime = Date.parse(new Date());
var deadLine = new Date(currentTime + SESSION_TIME * 60 * 1000);


//iframe height resize
function resizeFrame() {
    var scrollHeight = document.body.scrollHeight;
    var the_height= (scrollHeight < 600) ? 600 : scrollHeight;
    
    $(window.parent.document.getElementById('contentDiv')).css('height', the_height);
    $(window.parent.document.getElementById('contentDiv')).css('overflow', 'hidden');
}


function isEmpty(value) {
    return (value == null || value == '' || value == undefined);
}


//onPageLoadad();