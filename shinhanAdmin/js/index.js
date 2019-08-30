$(document).ready(function () {

    //메뉴 로드
    fnLoadMenu();


    //메뉴 클릭 시
    $(document).on('click', '#accordionSidebar li.nav-item > a', function (e) {
        var title = $(this).find('span').text();
        var url = $(this).attr('data-url');
        fnLoadPage(title, url);

        $('#accordionSidebar li.nav-item').removeClass('active');
        $(this).parent('li').addClass('active');
    });

    var userInfo = JSON.parse(window.sessionStorage.getItem('userInfo'));
    var empNm = userInfo['name'];
    $('#empProfileName').text(empNm);

});


//메뉴에 해당하는 페이지로 이동
function fnLoadPage(title, url) {
    $('#contentDiv').attr('src', url);
}


//메뉴 로드
function fnLoadMenu() {

    firebase.database().ref('/admin_menu/').once('value')
        .then(function (snapshot) {
            var menuArr = snapshot.val();
            var firstFlag = true;

            $.each(menuArr, function (idx, menuObj) {
                var newLi = $('#accordionSidebar li.nav-item.dummy').clone();
                $(newLi).find('span').text(menuObj['title']);
                $(newLi).find('i').addClass(menuObj['icon']);
                $(newLi).find('a').attr('data-url', menuObj['url']);

                $(newLi).removeClass('dummy');
                $(newLi).insertBefore('#accordionSidebar hr.sidebar-divider.d-none');

                if (firstFlag) {
                    $(newLi).addClass('active');
                    firstFlag = false;
                    fnLoadPage(menuObj['title'], menuObj['url']);
                }
            });
        });
}


firebase.auth().onAuthStateChanged(function (user) {
    if (user) {
        // User is signed in.
    } else {
        // No user is signed in.
        alert('Session is not found.');

        if (parent && parent != this) { //자식창 인 경우
            parent.location.href = '/login.html';
        } else { //부모창 인 경우
            window.location.href = '/login.html';
        }

    }

});