

$(document).ready(function () {

    //행추가 버튼 -> 페이지 이동
    $('#btnAdd').on('click', function(e) {
        e.preventDefault();
        window.location.href = "/view/registerNotice.html";
        //location.replace("http://localhost/view/addNotice.html");
    }); 


    /** start of components ***********************/
    $('#releaseYn').selectpicker();
    $('#regDate').text(moment().format('YYYY-MM-DD'));
    var userInfo = JSON.parse(window.sessionStorage.getItem('userInfo'));
    $('#writor').text(userInfo['empNm']);

    
    $('#daterange').daterangepicker({
        opens: 'right',
        minDate: moment(),
        locale: {
            format: 'YYYY-MM-DD'
        }
    }, function(start, end) {
        $('#daterange span').html(start.format('YYYY-MM-DD') + ' ~ ' + end.format('YYYY-MM-DD'));
    });


    //목록 버튼
    $('#btnList').on('click', function(e) {
        e.preventDefault();
        window.location.href = "/view/manageNotice.html";
     
    });
    
    
    //목록 이동
    function fnGoList() {
        var url = '/view/manageNotice.html';
    }


    //저장 버튼
    $('#btnSave').on('click', function(e) {
        e.preventDefault();
        
        if(!fnValidate()) {
            return false;
        }
        if(confirm('저장하시겠습니까?')) {

            fnSave(function() {
                alert('저장하였습니다');
                e.preventDefault();
                window.location.href = "/view/manageNotice.html";
                //fnGoList();
            });
        }
    });
    /** end of components *************************/


    //validataion
    function fnValidate() {
        var errMsg = '';
        var param = '';
        var target;

        if(isEmpty($('#title').val())) {
            param = ' 제목';
            target = $('#title');
        }
        else if(isEmpty(($('#daterange > span').text()))) {
            param = '게시기간';
            target = $('#daterange');
        }
        else if(isEmpty($('#releaseYn').val())) {
            param = '공개여부';
            target = $('#releaseYn');
        }else if(isEmpty($('#description').val())) {
            param = '내용';
            target = $('#description');
        }

        if(!isEmpty(param)) {
            errMsg = param + ' 은(는) 필수입력 입니다.';
            alert(errMsg);
            $(target).focus();
            return false;
        }

        return true;
    }

    //저장
    function fnSave(callback) {

        var contentWritor = $('#writor').text();
        var contentTitle=$('#title').val();
        var dateRangeFrom = $('#daterange').data('daterangepicker').startDate.format('YYYYMMDD');
        var dateRangeTo = $('#daterange').data('daterangepicker').endDate.format('YYYYMMDD');
        var releaseYn = $('#releaseYn').val();
        var contentDescription = $('#description').val();
                   
        setNotieDatabase({
            writor: contentWritor,
            description: contentDescription,
            date: moment().format('YYYYMMDD'),
            title: contentTitle,
            releaseYn: releaseYn,
            postingPeriodFrom: dateRangeFrom,
            postingPeriodTo: dateRangeTo
        }, callback);
    }


    function setNotieDatabase(paramObj, callback) {

        //var row
        var rowKey = 'notie_' + moment().unix(); 
        firebase.database().ref('/'+ '신한은행'+'/notie/' + rowKey).set({
        
            writor: paramObj['writor'],
            date: paramObj['date'],
            title: paramObj['title'],
            postingPeriodFrom: paramObj['postingPeriodFrom'],
            postingPeriodTo: paramObj['postingPeriodTo'],
            releaseYn: paramObj['releaseYn'],
            description: paramObj['description']
           
        }).then(function onSuccess(res) {
            if(callback != null && callback != undefined) {
                callback();
            }
        }).catch(function onError(err) {
            console.log("ERROR!!!! " + err);
        });
    }




    //ifame height resize
    resizeFrame();

});