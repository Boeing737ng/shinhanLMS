

$(document).ready(function () {

    const ROW_KEY = getParams().rowKey;

    /** start of components ***********************/
    $('#releaseYn').selectpicker();
    $('#category').selectpicker();
    $('#regDate').text(moment().format('YYYY-MM-DD'));
    var userInfo = JSON.parse(window.sessionStorage.getItem('userInfo'));

   

    $('#daterange').daterangepicker({
        opens: 'right',
        minDate: moment(),
        locale: {
            format: 'YYYY-MM-DD'
        }
    }, function(start, end) {
        $('#daterange span').html(start.format('YYYY-MM-DD') + ' ~ ' + end.format('YYYY-MM-DD'));
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
                fnGoList();
            });
        }
    });


    //목록 버튼
    $('#btnList').on('click', function(e) {
        e.preventDefault();
        fnGoList();
    });

   

  
    /** end of components *************************/


    /** start of functions ***********************/
    function fnRetrieve() {
        
        parent.database.ref('/'+ '신한은행'+'/notie/' + ROW_KEY).once('value').then(function(snapshot) {

            var obj = snapshot.val();
            
            $('#title').val(obj['title']);
            $('#writor').text(obj['writor']);
            $('#description').val(obj['description']);
            $('#releaseYn').val(obj['releaseYn']);
            $('#releaseYn').selectpicker('refresh');
            //$('#daterange').

        });
    }


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
        var url = '/view/manageNotice.html';
        var paramObj = getParams();

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

        if(isEmpty($('#title').val())) {
            param = ' 제목';
            target = $('#title');
        }
        else if($('#description').tagsinput('items').length == 0) {
            param = '내용';
            target = $('description');
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
        //var dateRangeFrom = $('#daterange').data('daterangepicker').startDate.format('YYYYMMDD');
        //var dateRangeTo = $('#daterange').data('daterangepicker').endDate.format('YYYYMMDD');
        //var releaseYn = $('#releaseYn').val();
        var contentDescription = $('#description').val();
                   
        setNotieDatabase({
            writor: contentWritor,
            description: contentDescription,
            date: moment().format('YYYYMMDD'),
            title: contentTitle
            //releaseYn: releaseYn,
            //postingPeriodFrom: dateRangeFrom,
            //postingPeriodTo: dateRangeTo
        }, callback);
    }


    function setNotieDatabase(paramObj, callback) {

        //var row
        parent.database.ref('/'+ '신한은행'+'/notie/' + ROW_KEY).set({
        
            writor: paramObj['writor'],
            date: paramObj['date'],
            title: paramObj['title'],
            //postingPeriodFrom: paramObj['postingPeriodFrom'],
            //postingPeriodTo: paramObj['postingPeriodTo'],
            //releaseYn: paramObj['releaseYn'],
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

    fnRetrieve();

});