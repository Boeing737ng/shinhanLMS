

$(document).ready(function () {

    /** start of components ***********************/
    $('#releaseYn').selectpicker();
    $('#regDate').text(moment().format('YYYY-MM-DD'));

    var userInfo = JSON.parse(window.sessionStorage.getItem('userInfo'));
    var compCd = userInfo['compCd'];

    $('#writor').text(userInfo['name']);


    $('#btnAddEmp').on('click', function(e) {

        e.preventDefault();

        var popup = SearchEmpListPopup.getInstance({
            title: '사원 검색'
        });

        $(popup).off('submit').on('submit', function(e, param) {
            var records = param['records'];
            $('#empGrid').jsGrid('option', 'data', records);
        });

        popup.open();
        
    });


    $('#btnLoadEmpNonWatch').on('click', function(e) {

        e.preventDefault();

        var popup = searchEmpListNonWatchPopup.getInstance({
            title: '필수강좌 미이수자 검색'
        });

        $(popup).off('submit').on('submit', function(e, param) {
            var records = param['records'];
            $('#empGrid').jsGrid('option', 'data', records);
        });

        popup.open();
        
    });


    //목록 버튼
    $('#btnList').on('click', function(e) {
        e.preventDefault();
        fnGoList();
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


    /** start of grid ***********************/
    $("#empGrid").jsGrid({
        width: "100%",
        height: "200px",
        sorting: true,
        paging: false,
        data: [],
        fields: [
            { name: "empNo", title: '사번', type: "text", width: 100, editing: false, align: "center" },
            { name: "name", title: '성명', type: "text", width: 100, editing: false, align: "center" },
            { name: "compNm", title: "회사명", type: 'text', width: 150, editing: false, align: "left" },
            { name: "department", title: '부서명', type: "text", width: 200, editing: false, align: "left" }
        ]
    });
    /** end of grid *************************/


    function getParams() {
        var param = {}
     
        // 현재 페이지의 url
        var url = decodeURIComponent(location.href);
        url = decodeURIComponent(url);
        
        if(url.split('?').length > 1) {

            var params = url.split('?')[1];

            if(params.length == 0) {
                return param;
            }

            params = params.split("&");

            var size = params.length;
            var key, value;

            for(var i=0 ; i < size ; i++) {
                key = params[i].split("=")[0];
                value = params[i].split("=")[1];
        
                param[key] = value;
            }
        }
        
        return param;
    }
    
    
    //목록 이동
    function fnGoList() {
        var paramObj = getParams();
        var url = paramObj['listUrl'];

        fnGo(url, paramObj);
    }


    function fnGo(url, paramObj) {
        var form = $('<form></form>');
        $(form).attr('method', 'get');
        $(form).attr('action', url);
        
        $.each(paramObj, function(key, value) {
            var input = $('<input type="hidden"/>');
            $(input).attr('name', key);
            $(input).val(value);

            $(form).append(input);
        });

        console.log(paramObj);

        $('body').append(form);
        $(form).submit();
    }


    //validataion
    function fnValidate() {
        var errMsg = '';
        var param = '';
        var target;

        var empGridRowCnt = $('#empGrid').jsGrid('option', 'data').length;

        if(empGridRowCnt == 0) {
            param = '수신자 리스트';
            target = $('#btnAddEmp');
        }
        else if(isEmpty($('#title').val())) {
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

        var userRecords = $('#empGrid').jsGrid('option', 'data');
        var targetUsers = {};

        for(var i=0; i<userRecords.length; i++) {
            var user = userRecords[i];
            var empNo = user.empNo;
            var empNm = user.name;
            var compNm = user.compNm;
            var deptNm = user.department;

            var newObj = {
                'name': empNm,
                'compNm': compNm,
                'department': deptNm,
                'noticeId': moment().unix()
            };

            targetUsers[empNo] = newObj;
        }

        setNotieDatabase({
            writor: contentWritor,
            description: contentDescription,
            date: moment().format('YYYYMMDD'),
            title: contentTitle,
            targetUsers: targetUsers
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