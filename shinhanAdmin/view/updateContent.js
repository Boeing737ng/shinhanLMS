

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
    //db에서 불러오는 함수 
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
        var url = '/view/manageContents.html';
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


    //canvas 그리기
    function drawCanvas(imgUrl){
 
        //이미지 객체 생성
        var imgClo = new Image();

        //페이지 로드후 이미지가 로드 되었을 때 이미지 출력
        imgClo.addEventListener('load', function(){
            //로드된 이미지를 캔버스에 출력
            var ctx = document.getElementById('canvas').getContext("2d");

            //canvas.drawImage() 함수를 사용하여 이미지 출력
            ctx.drawImage( imgClo , 0, 0, 300, 150);
            $('#canvas').attr('data-url', imgUrl);
       
        },false);

        //이미지 경로 설정
        imgClo.src= imgUrl;
        
    }


    //validataion
    function fnValidate() {
        var errMsg = '';
        var param = '';
        var target;

        if($('#video > source').length == 0) {
            param = '동영상';
            target = $('#video');
        }else if(isEmpty($('#title').val())) {
            param = '컨텐츠명';
            target = $('#title');
        }else if(isEmpty($('#author').val())) {
            param = '강사명';
            target = $('#author');
        }else if(isEmpty($('#releaseYn').val())) {
            param = '공개여부';
            target = $('#releaseYn');
        }else if(isEmpty($('#category').val())) {
            param = '카테고리';
            target = $('#category');
        }else if($('#relatedTags').tagsinput('items').length == 0) {
            param = '관련태그';
            target = $('#relatedTags');
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


    function setVideoDatabase(rowId, paramObj, callback) {

        firebase.database().ref('videos/' + rowId + '/').set({
            downloadURL: paramObj['downloadURL'],
            author: paramObj['author'],
            category: paramObj['category'],
            tags: paramObj['tags'],
            description: paramObj['description'],
            date: paramObj['date'],
            thumbnail: paramObj['thumbnail'],
            title: paramObj['title'],
            releaseYn: paramObj['releaseYn']
        }).then(function onSuccess(res) {
            if(callback != null && callback != undefined) {
                callback();
            }
        }).catch(function onError(err) {
            console.log("ERROR!!!! " + err);
        });
    }


    function replaceBlankSpace(string) {
        return string.replace(' ','_');
    }


    //id 채번
    function fnGetPrimaryKey(title) {
        return replaceBlankSpace(title) + '_' + moment().unix();
    }


    //dataUrl --> Blob
    function fnConvertDataUrlToBlob(dataURL) {
        const BASE64_MARKER = ";base64,";
      
        // base64로 인코딩 되어있지 않을 경우
        if (dataURL.indexOf(BASE64_MARKER) === -1) {
          const parts = dataURL.split(",");
          const contentType = parts[0].split(":")[1];
          const raw = parts[1];
          return new Blob([raw], {
            type: contentType
          });
        }

        // base64로 인코딩 된 이진데이터일 경우
        const parts = dataURL.split(BASE64_MARKER);
        const contentType = parts[0].split(":")[1];
        const raw = window.atob(parts[1]);
        // atob()는 Base64를 디코딩하는 메서드
        const rawLength = raw.length;
        // 부호 없는 1byte 정수 배열을 생성 
        const uInt8Array = new Uint8Array(rawLength); // 길이만 지정된 배열
        
        var i = 0;
        while (i < rawLength) {
          uInt8Array[i] = raw.charCodeAt(i);
          i++;
        }

        return new Blob([uInt8Array], {
          type: contentType
        });
    }


    //video load
    function fnLoadVideo(videoUrl) {
        var video = document.getElementById('video');
        video.pause();

        var source = document.createElement('source');
        source.type = 'video/mp4';
        source.src = videoUrl;

        video.innerHTML = '';
        video.appendChild(source);
        
        video.load();
    }
    /** end of functions *************************/


    //ifame height resize
    resizeFrame();

    fnRetrieve();

});