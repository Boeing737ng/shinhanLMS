

$(document).ready(function () {

    /** start of components ***********************/
    $('#releaseYn').selectpicker();
    $('#regDate').text(moment().format('YYYY-MM-DD'));

    var userInfo = JSON.parse(window.sessionStorage.getItem('userInfo'));
    var compCd = userInfo['compCd'];
    
    $('#writor').text(userInfo['name']);


    //목록 버튼
    $('#btnList').on('click', function(e) {
        e.preventDefault();
        window.location.href = "/view/manageNotice.html";
     
    });
    

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


    //목록 이동
    function fnGoList() {
        var url = '/view/manageNotice.html';
    }


    //validataion
    function fnValidate() {
        var errMsg = '';
        var param = '';
        var target;

        if(isEmpty($('#title').val())) {
            param = ' 제목';
            target = $('#title');
        }
        else if(isEmpty($('#description').val())) {
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
        var contentDescription = $('#description').val();
                   
        setNotieDatabase({
            writor: contentWritor,
            description: contentDescription,
            date: moment().format('YYYYMMDD'),
            title: contentTitle
        }, callback);
    }


    function setNotieDatabase(paramObj, callback) {

        //var row
        var rowKey = 'notie_' + moment().unix(); 

        parent.database.ref('/'+ compCd +'/notie/' + rowKey).set(paramObj).then(function onSuccess(res) {
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