

$(document).ready(function () {

    const ROW_KEY = getParams().rowKey;

    /** start of components ***********************/
    $('#releaseYn').selectpicker();
    $('#category').selectpicker();


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
        
        firebase.database().ref('/videos/' + ROW_KEY).once('value').then(function(snapshot) {

            var obj = snapshot.val();
            
            $('#title').val(obj['title']);
            $('#author').val(obj['author']);
            $('#description').val(obj['description']);

            var tagArr = obj['tags'].split(' ');
            for(var i=0; i<tagArr.length; i++) {
                $('#relatedTags').tagsinput('add', tagArr[i]);    
            }
            
            $('#releaseYn').val(obj['releaseYn']);
            $('#releaseYn').selectpicker('refresh');

            $('#category').val(obj['category']);
            $('#category').selectpicker('refresh');

            fnLoadVideo(obj['downloadURL']);
            drawCanvas(obj['thumbnail']);
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
        else if(isEmpty($('#daterange').val())) {
            param = '게시기간';
            target = $('#daterange');
        }
        else if(isEmpty($('#releaseYn').val())) {
            param = '공개여부';
            target = $('#releaseYn');
        }else if($('#description').tagsinput('items').length == 0) {
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

        var contentAuthor = $('#author').val();
        var contentCategory = $('#category').val();
        
        var contentTagArr = $('#relatedTags').tagsinput('items');
        for(var i=0; i<contentTagArr.length; i++) {
            contentTagArr[i] = replaceBlankSpace(contentTagArr[i]);
        }
        
        var contentTag = contentTagArr.join(' ');
        var downloadURL = $('#video > source').attr('src');
        var thumbnailPath = $('#canvas').attr('data-url');
        var contentDescription = $('#description').val();
        var contentAddedTime = moment().unix();
        var title = $('#title').val();
        var releaseYn = $('#releaseYn').val();


        firebase.database().ref('videos/' + ROW_KEY + '/').update({
            downloadURL: downloadURL,
            author: contentAuthor,
            category: contentCategory,
            tags: contentTag,
            description: contentDescription,
            date: contentAddedTime,
            thumbnail: thumbnailPath,
            title: title,
            releaseYn: releaseYn
        }).then(function onSuccess(res) {
            if(callback != null && callback != undefined) {
                callback();
            }
        }).catch(function onError(err) {
            console.log("ERROR!!!! " + err);
        });
    }
    

    function setTagDatabase(contentTagArr, callback) {
        for(var i=0; i<contentTagArr.length; i++) {
            firebase.database().ref('tag/' + contentTagArr[i] + '/').update({
                'tag': contentTagArr[i]
            }).then(function onSuccess(res) {
                if(callback != null && callback != undefined) {
                    callback();
                }
            }).catch(function onError(err) {
                console.log("ERROR!!!! " + err);
            });
        }
    }


   




  




    //ifame height resize
    resizeFrame();

    fnRetrieve();

});