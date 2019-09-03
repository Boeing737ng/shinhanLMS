Dropzone.autoDiscover = false;


$(document).ready(function () {

    var submitVideoAttachFile; //영상 - 실제 저장 시 이용될 file input
    var submitThumbnailAttachFile; //썸네일 - 실제 저장 시 이용될 file input
    var userObj = JSON.parse(window.sessionStorage.getItem('userInfo'));
    var compCd = userObj['compCd'];
    var compNm = userObj['compNm'];
    const MAX_TAGS_CNT = 5;


    /** start of components ***********************/
    window.FakeLoader.init();


    //var myDropzone = new Dropzone("div#dropzone", { url: "/file/post"});


    $('#relatedTags').tagsinput({
        maxTags: MAX_TAGS_CNT
    });


    $('#lectureRequireYn').selectpicker();
    fnGetCommonCmb('category', '#category');


    $('#category').on('change', function(e) {
        $('#requireYn').text($('#category > option:selected').attr('data-requireYn') || 'N');
    });


    $('#output').on('click', function(e) {
        $('#lectureThumbnailFile').click();
    });


    $('#btnUploadVideo').on('click', function(e) {
        e.preventDefault();
        $('#videoAttachFile').click();
    });


    $('#lectureThumbnailFile').on('change', function(e) {

        if(document.getElementById("lectureThumbnailFile").files.length == 0) {
            return false;
        }

        var ext = $(this).val().split('.').pop().toLowerCase(); //확장자
        
        //배열에 추출한 확장자가 존재하는지 체크
        if($.inArray(ext, ['gif', 'png', 'jpg', 'jpeg']) == -1) {
            resetFormElement($(this)); //폼 초기화
            window.alert('이미지 파일이 아닙니다! (gif, png, jpg, jpeg 만 업로드 가능)');
        } else {
            submitThumbnailAttachFile = $('#lectureThumbnailFile').clone();

            var output = document.getElementById('output');
            var filesArr = Array.prototype.slice.call(e.target.files);
            var file = filesArr[0];
            var blobURL = window.URL.createObjectURL(file);

            var img = document.createElement('img');
            img.width = 160;
            img.height = 90;

            $(img).on('load', function(e) {
                var canvas = capture('image', img);
                output.innerHTML = '';
                $(output).css('background-color', 'black');
                $(output).css('background-image', '');
                output.appendChild(canvas);
            });

            img.src = blobURL;
        }
    });


    var video = document.getElementById('video');
    var scaleFactor = 0.25;


    $('#video').on('click', function(e) {
        $('#videoAttachFile').click();
    });


    $('#videoAttachFile').on('change', function(e) {
        if(document.getElementById("videoAttachFile").files.length == 0) {
            return false;
        }

        var ext = $(this).val().split('.').pop().toLowerCase(); //확장자
        if($.inArray(ext, ['mp4', 'webm']) == -1) {
            resetFormElement($(this)); //폼 초기화
            window.alert('동영상 파일이 아닙니다! (mp4, webm 만 업로드 가능)');
            return false;
        }

        submitVideoAttachFile = $('#videoAttachFile').clone();

        var files = document.getElementById("videoAttachFile").files;

        for(var i=0; i<files.length; i++) {
            var file = document.getElementById("videoAttachFile").files[i];
            var type = file.type;

            var URL = window.URL || window.webkitURL;
            var fileURL = URL.createObjectURL(file);
            var defaultFileNm = file.name.split('.')[0];

            var canvas = document.getElementById('canvas');

            if(!isEmpty(canvas)) {
                var dataUrl = canvas.toDataURL('image/png');
                var defaultThumbnailUrl = dataUrl;
            }
            
            $('#contentGrid').jsGrid('insertItem', {
                title: defaultFileNm || '', 
                videoFileNm: file.name || '',
                uploadURL: fileURL || '', 
                thumbnail: defaultThumbnailUrl || ''
            });
        }
    });


    $('#videoThumbnailFile').on('change', function(e) {

        if(document.getElementById("videoAttachFile").files.length == 0) {
            return false;
        }

        var ext = $(this).val().split('.').pop().toLowerCase(); //확장자
        if($.inArray(ext, ['jpeg', 'jpg', 'png']) == -1) {
            resetFormElement($(this)); //폼 초기화
            window.alert('이미지 파일이 아닙니다! (jpeg, jpg, png 만 업로드 가능)');
            return false;
        }

        var file = document.getElementById("videoAttachFile").files[0];
        var type = file.type;

        var URL = window.URL || window.webkitURL;
        var fileURL = URL.createObjectURL(file);
        var defaultFileNm = file.name.split('.')[0];

        var canvas = document.getElementById('canvas');

        if (!isEmpty(canvas)) {
            var dataUrl = canvas.toDataURL('image/png');
            var defaultThumbnailUrl = dataUrl;
        }

        $('#contentGrid').jsGrid('updateItem', {
            title: defaultFileNm || '',
            videoFileNm: file.name || '',
            uploadURL: fileURL || '',
            thumbnail: defaultThumbnailUrl || ''
        });
    });


    /* video.addEventListener('loadedmetadata', function () {
        $(video).one('seeked', function(e) {
            shoot();
        });

        this.currentTime = this.duration / 2;
    }, false); */


    //저장 버튼
    $('#btnSave').on('click', function(e) {
        e.preventDefault();
        
        if(!fnValidate()) {
            return false;
        }

        if(confirm('저장하시겠습니까?')) {
            
            window.FakeLoader.showOverlay();
            
            fnSave(function() {
                window.FakeLoader.hideOverlay();
                alert('저장하였습니다');
                fnGoList();
            });
        }
    });


    //행삭제 버튼
    $('#btnDel').on('click', function(e) {
        e.preventDefault();

        if(selectedItems.length == 0) {
            alert('선택된 데이터가 없습니다.');
            return false;
        }

        removeCheckedRows();
    });


    //목록 버튼
    $('#btnList').on('click', function(e) {
        e.preventDefault();
        fnGoList();
    });
    /** end of components *************************/


    /** start of grid ***********************/
    $("#contentGrid").jsGrid({
        width: "100%",
        height: "400px",
        editing: true,
        //inserting: true,
        sorting: true,
        paging: false,
        selecting: true,
        data: [],

        /* nextEdit: false,
        rowClick: function(args) {
            if (this._editingRow)
            {
            this.updateItem();
            this.nextEdit = args.event.target;
            }
            else if(this.editing)
            {
            this.editItem($(args.event.target).closest("tr"));
            }
        }, */
      /* onItemUpdated: function()
      {
        if(this.nextEdit)
        {
          this.editItem($(this.nextEdit).closest("tr"));
          this.nextEdit = false;
        }
      }, */
        

        /* onItemInserting: function(args) {
            if(!confirm('추가하시겠습니까?')) {
                args.cancel = true;
            }
        }, */

        /* onItemInserted: function(args) { //신규
            var item = args.item;

            fnCreate(item, function() {
                alert('저장되었습니다.');
                fnRetrieve();
            });
        }, */

        /* rowClick: function(args) {
            var $row = this.rowByItem(args.item),
            selectedRow = $("#grid").find('table tr.highlight');

            if (selectedRow.length) {
                selectedRow.toggleClass('highlight');
            };
            
            $row.toggleClass("highlight");

            fnRetrieveDetail(args.item);
            
        }, */

        fields: [
            {
                itemTemplate: function(_, item) {
                    return $("<input>").attr("type", "checkbox")
                            .addClass('selectionCheckbox')
                            .prop("checked", $.inArray(item, selectedItems) > -1)
                            //.prop('disabled', (item.rowKey == 'REQUIRED'))
                            .on("change", function () {
                                $(this).is(":checked") ? selectItem(item) : unselectItem(item);
                            });
                },
                align: "center",
                width: 30
            },
            { name: "thumbnail", title: '썸네일', width: 80, editing: false, align: "center", cellRenderer: function(item, value) {
                var rslt = $("<td>").addClass("jsgrid-cell");
                var canvas = $('<canvas/>');
                
                $(canvas).css('width', '60px');
                $(canvas).css('height', '45px');
                $(canvas).css('cursor', 'pointer');
                $(canvas).attr('src', item);
                $(rslt).append(canvas);
                
                return rslt;
            }, editTemplate: function(item, value) {
                
                var canvas = $('<canvas/>');
                
                $(canvas).css('width', '60px');
                $(canvas).css('height', '45px');
                $(canvas).css('cursor', 'pointer');
                
                $(canvas).on('click', function(e) {
                    $('#videoThumbnailFile').click();
                });
                
                $(canvas).attr('src', item);

                return canvas;
            } },
            { name: "title", title: '강의명', type: "text", width: 200, align: "left", editing: true, validate: {
                validator: 'required', 
                message: '강의명 은 필수입력 입니다.'
            } },
            { name: "videoFileNm", title: '파일', type: "text", width: 200, editing: false, align: "left" }
            ,
            { type: "control", deleteButton: false } //edit control
        ]
    });
    /** end of grid *************************/


    /** start of functions ***********************/
    var selectedItems = [];
 
    function selectItem(item) {
        selectedItems.push(item);
    };

    function unselectItem(item) {
        selectedItems = $.grep(selectedItems, function(i) {
            return i !== item;
        });
    }


    //체크된 건들 삭제
    function removeCheckedRows(callback) {
        for(var i=0; i<selectedItems.length; i++) {
            var item = selectedItems[i];
            var rowKey = item['rowKey'];
            $('#contentGrid').jsGrid('deleteItem', item);
            //fnDeleteDatabase(rowKey, null)
        }

        if(callback != null && callback != undefined) {
            callback();
        }

        selectedItems = [];
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
        var url = '/view/manageLecture.html';
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

        $('body').append(form);
        $(form).submit();
    }
    
    
    function resetFormElement(e) {
        e.wrap('<form>').closest('form').get(0).reset(); 
        //리셋하려는 폼양식 요소를 폼(<form>) 으로 감싸고 (wrap()) , 
        //요소를 감싸고 있는 가장 가까운 폼( closest('form')) 에서 Dom요소를 반환받고 ( get(0) ),
        //DOM에서 제공하는 초기화 메서드 reset()을 호출
        e.unwrap(); //감싼 <form> 태그를 제거
    }

    /**
     * Captures a image frame from the provided video element.
     *
     * @param {Video} video HTML5 video element from where the image frame will be captured.
     * @param {Number} scaleFactor Factor to scale the canvas element that will be return. This is an optional parameter.
     *
     * @return {Canvas}
     */
    function capture(option, content) {
        var canvas = document.createElement('canvas');
        canvas.id = 'canvas';
        var w = 160;
        var h = 90;
        canvas.width  = w;
        canvas.height = h;

        var ctx = canvas.getContext('2d');

        switch(option) {
            case 'image':
                ctx.drawImage(content, 0, 0, w, h);
                console.log('?');
                break;
            case 'video':
                ctx.drawImage(content, 0, 0, w, h);
                break; 
        }
        
        return canvas;
    } 

    /**
     * Invokes the <code>capture</code> function and attaches the canvas element to the DOM.
     */
    function shoot() {
        var video  = document.getElementById('video');
        var output = document.getElementById('output');
        
        var canvas = capture('video', video);
        output.innerHTML = '';
        output.appendChild(canvas);
    }


    //영상 업로드
    function fnUploadVideo(rowId, callback) {

        var contentFile = $(submitVideoAttachFile).prop('files')[0];
        var uploadTask = firebase.storage().ref('videos/' + rowId).put(contentFile, {contentType: null});

        uploadTask.on(firebase.storage.TaskEvent.STATE_CHANGED,
            function(snapshot) {
                //progressbar 갱신
                var progress = (snapshot.bytesTransferred / snapshot.totalBytes) * 100;
                $('#video').siblings('div.progress').find('div.progress-bar').css('width', progress + '%');
                
                switch (snapshot.state) {
                case firebase.storage.TaskState.PAUSED:
                    console.log('Upload is paused');
                    break;
                case firebase.storage.TaskState.RUNNING:
                    break;
                }
            }, function(error) {
                switch (error.code) {
                    case 'storage/unauthorized':
                        break;
                    case 'storage/canceled':
                        break;
                    case 'storage/unknown':
                        break;
                }

                window.FakeLoader.hideOverlay();
            }, function() {
                uploadTask.snapshot.ref.getDownloadURL().then(function(downloadURL) {
                    if(callback != null && callback != undefined) {
                        callback(downloadURL);
                    }
                });
            }
        );
    }


    //썸네일 업로드
    function fnUploadThumbnail(rowId, callback) {

        var canvas = document.getElementById('canvas');
        var dataUrl = canvas.toDataURL('image/png');
        var contentFile = fnConvertDataUrlToBlob(dataUrl);

        var uploadTask = firebase.storage().ref('thumbnail/' + rowId).put(contentFile, {contentType: null});

        uploadTask.on(firebase.storage.TaskEvent.STATE_CHANGED,
            function(snapshot) {
                //progressbar 갱신
                var progress = (snapshot.bytesTransferred / snapshot.totalBytes) * 100;

                switch (snapshot.state) {
                case firebase.storage.TaskState.PAUSED:
                    console.log('Upload is paused');
                    break;
                case firebase.storage.TaskState.RUNNING:
                    break;
                }
            }, function(error) {
                switch (error.code) {
                    case 'storage/unauthorized':
                        break;
                    case 'storage/canceled':
                        break;
                    case 'storage/unknown':
                        break;
                }

                window.FakeLoader.hideOverlay();
            }, function() {
                uploadTask.snapshot.ref.getDownloadURL().then(function(downloadURL) {
                    if(callback != null && callback != undefined) {
                        callback(downloadURL);
                    }
                });
            }
        );
    }


    //validataion
    function fnValidate() {
        var errMsg = '';
        var param = '';
        var target;

        if(isEmpty($('#title').val())) {
            param = '강좌명';
            target = $('#title');
        }else if(isEmpty($('#output').html())) {
            param = '썸네일';
            target = $('#output');
        }else if(isEmpty($('#author').val())) {
            param = '강사명';
            target = $('#author');
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

        (function () {
            var thumbnailPath = '';
            var rowId = fnGetPrimaryKey(); //id 채번

            fnUploadThumbnail(rowId, function (downloadURL) {

                thumbnailPath = downloadURL;

                var contentTagArr = $('#relatedTags').tagsinput('items');
                for (var i = 0; i < contentTagArr.length; i++) {
                    contentTagArr[i] = replaceBlankSpace(contentTagArr[i]);
                }
                var contentTag = contentTagArr.join(' ');

                setLectureDatabase(rowId, {
                    author: $('#author').val(),
                    categoryId: $('#category').val(),
                    categoryNm: $('#category > option:selected').text(),
                    tags: contentTag,
                    thumbnail: thumbnailPath,
                    description: $('#description').val(),
                    date: moment().format('YYYYMMDDHHmmss'),
                    title: $('#title').val(),
                    requireYn: $('#lectureRequireYn').val(),
                    view: 0
                }, callback);
            });

        })();
    }


    function setLectureDatabase(rowId, paramObj, callback) {

        parent.database.ref('/' + compCd + '/lecture/' + rowId + '/').set(paramObj).then(function onSuccess(res) {
            if(callback != null && callback != undefined) {
                callback();
            }
        }).catch(function onError(err) {
            console.log("ERROR!!!! " + err);
            window.FakeLoader.hideOverlay();
        });
    }


    function replaceBlankSpace(string) {
        return string.replace(' ','_');
    }


    //id 채번
    function fnGetPrimaryKey() {
        return 'lecture_' + moment().unix();
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


    //combo 구성
    function fnGetCommonCmb(option, selector, defaultValue) {

        $('' + selector).html('');
        $('' + selector).html('<option value="">전체</option>');

        switch(option) {
            case 'category':
                    parent.database.ref('/' + compCd + '/categories/').once('value')
                    .then(function (snapshot) {
                        var catArr = snapshot.val();
                        var optionArr = [];
                    
                        $.each(catArr, function(idx, catObj) {
                            var newOption = $('<option></option>');
                            $(newOption).attr('value', idx);
                            $(newOption).attr('data-requireYn', catObj['requireYn']);
                            $(newOption).text(catArr[idx].title);

                            if(idx == defaultValue) {
                                $(newOption).attr('selected', 'selected');
                            }

                            $(''+selector).append($(newOption));
                        });
    
                        $(''+selector).selectpicker();
                    });    
                break; 
        }
    }
    /** end of functions *************************/


    //ifame height resize
    resizeFrame();

});