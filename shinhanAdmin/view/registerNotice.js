

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
    //$('#date').datepicker();
    
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

    $.datepicker.setDefaults({
        dateFormat: 'yy-mm-dd' //Input Display Format 변경
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
    rowDoubleClick: function(args) {
        var arr = $('#grid').jsGrid('option', 'data');
        
        fnGo('/view/updateContent.html', {
            'searchReleaseYn' : $('#searchReleaseYn').val(),
            'searchCategory' : $('#searchCategory').val(),
            'searhRelatedTag': $('#searhRelatedTag').val(),
            'searchTitle': $('#searchTitle').val(),
            'rowKey': arr[args.itemIndex]['rowKey']
        });
    },

    fields: [
        {
            itemTemplate: function(_, item) {
                return $("<input>").attr("type", "checkbox")
                        .addClass('selectionCheckbox')
                        .prop("checked", $.inArray(item, selectedItems) > -1)
                        .on("change", function () {
                            $(this).is(":checked") ? selectItem(item) : unselectItem(item);
                        });
            },
            align: "center",
            width: 30
        },
        { name: "thumbnail", title: '썸네일', width: 80, editing: false, align: "center", cellRenderer: function(item, value) {
            var rslt = $("<td>").addClass("jsgrid-cell");
            var img = $('<img/>');
            
            $(img).css('width', '60px');
            $(img).css('height', '45px');
            $(img).attr('src', item);
            $(rslt).append(img);
            
            return rslt;
        }, editTemplate: function(item, value) {
            
            var img = $('<img/>');
            
            $(img).css('width', '60px');
            $(img).css('height', '45px');
            $(img).attr('src', item);
            
            return img;
        } },
        { name: "title", title: '컨텐츠명', type: "text", width: 150, editing: false, align: "left" },
        { name: "author", title: '강사명', type: "text", width: 120, editing: false, align: "left" },
        { name: "category", title: "카테고리", type: 'text', width: 200, editing: false, align: "left" },
        { name: "tags", title: "관련태그", type: 'text', width: 200, editing: false, align: "left", cellRenderer: function(item, value){
            var rslt = $("<td>").addClass("jsgrid-cell");
            var div = $('<div></div>');
            $(rslt).append(div);

            if(isEmpty(item)) {
                return rslt;
            }

            var arr = item.split(' ');
            for(var i=0; i<arr.length; i++) {
                $(div).append($('<span class="tag label label-info" style="margin-right:5px; display:inline-block;">'+arr[i]+'</span>'));
            }
            return rslt; 
          }, editTemplate: function(item, value) {
            var div = $('<div></div>');
            
            if(isEmpty(item)) {
                return div;
            }
            
            var arr = item.split(' ');
            
            for(var i=0; i<arr.length; i++) {
                $(div).append($('<span class="tag label label-info" style="margin-right:5px; display:inline-block;">'+arr[i]+'</span>'));
            }

            return div; 
        } },

        //{ name: "description", title: "설명", type: 'textarea', align: "left", width: 200 },
        { name: "releaseYn", title: "공개여부", type: 'select', items: [
            { Name: "전체", Id: "" },
            { Name: "Y", Id: "Y" },
            { Name: "N", Id: "N" }
        ],valueField: "Id", textField: "Name", width: 100, editing: true, validate: {
            validator: 'required', 
            message: '공개여부 는 필수입력 입니다.'
        }, align: "center" },
        { type: "control" } //edit control
    ]
});


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

        var contentWritor = $('#writor').text();
        var contentTitle=$('#title').val();
        var dateRangeFrom = $('#daterange').data('daterangepicker').startDate;
        var dateRangeTo = $('#daterange').data('daterangepicker').endDate;
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
            postingPeriodFrom: dateRangeFrom,
            postingPeriodTo: dateRangeTo,
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