
$(document).ready(function () {

    window.FakeLoader.init( );
    var userObj = JSON.parse(window.sessionStorage.getItem('userInfo'));
    var compCd = userObj['compCd'];
    var compNm = userObj['compNm'];

    /** start of grid ***********************/
    $("#lectureGrid").jsGrid({
        width: "100%",
        height: "300px",
        editing: true,
        //inserting: true,
        sorting: true,
        paging: false,
        selecting: true,
        data: [],

        onItemInserting: function(args) {
            if(!confirm('추가하시겠습니까?')) {
                args.cancel = true;
            }
        },

        onItemInserted: function(args) { //신규
            var item = args.item;

            fnCreate(item, function() {
                alert('저장되었습니다.');
                fnRetrieve();
            });
        },

        onItemUpdating: function(args) {
            if(!confirm('수정하시겠습니까?')) {
                args.cancel = true;
            }
        },

        onItemUpdated: function(args) {
            var rowKey = args.item.rowKey;
            var item = args.item;
            delete item['rowKey']; 
            
            fnUpdateDatabase('lecture', rowKey, item, function() {
                alert('수정되었습니다.');
                fnRetrieve();
            });
        },

        onItemDeleting: function(args) {
            if(!confirm('삭제하시겠습니까?')) {
                args.cancel = true;
            }
        },

        onItemDeleted: function(args) {
            var rowKey = args.item.rowKey;
            
            fnDeleteDatabase('lecture', rowKey, function() {
                alert('삭제되었습니다.');
                fnRetrieve();
            });
        },

        rowClick: function(args) {
            fnRetrieveDetail(args.item);
            
            var $row = this.rowByItem(args.item),
            selectedRow = $("#lectureGrid").find('table tr.highlight');

            if (selectedRow.length) {
                selectedRow.toggleClass('highlight');
            };
            
            $row.toggleClass("highlight");
        },

        fields: [
            {
                itemTemplate: function(_, item) {
                    return $("<input>").attr("type", "checkbox")
                            .addClass('selectionCheckbox')
                            .prop("checked", $.inArray(item, selectedItemsLecture) > -1)
                            //.prop('disabled', (item.rowKey == 'REQUIRED'))
                            .on("change", function () {
                                $(this).is(":checked") ? selectItem('lecture', item) : unselectItem('lecture', item);
                            });
                },
                align: "center",
                width: '30px'
            },
            { name: "thumbnail", title: '썸네일', width: 80, editing: false, align: "center", cellRenderer: function(item, value) {
                var rslt = $("<td>").addClass("jsgrid-cell");
                var img = $("<img>");
                
                $(img).css('width', '60px');
                $(img).css('height', '45px');
                $(img).attr('src', item);
                $(rslt).append(img);
                
                return rslt;
            }, editTemplate: function(item, value) {
                
                var img = $('<img>');
                
                $(img).css('width', '60px');
                $(img).css('height', '45px');
                $(img).attr('src', item);
                
                return img;
            } },
            { name: "title", title: '강좌명', type: "text", width: 200, align: "left", cellRenderer: function(item, value) {
                var rslt = $("<td>").addClass("jsgrid-cell");
                var aLink = $("<a>");
                $(aLink).attr('href', '#');
                $(aLink).text(item);

                (function(value) {

                    $(aLink).on('click', function(e) {

                        e.preventDefault();
    
                        fnGo('/view/updateLecture.html', {
                            'searchRequireYn' : $('#searchRequireYn').val(),
                            'searchCategory' : $('#searchCategory').val(),
                            'searhRelatedTag': $('#searhRelatedTag').val(),
                            'searchTitle': $('#searchTitle').val(),
                            'rowKey': value['rowKey']
                        });
                    });

                }(value));

                $(rslt).append(aLink);
                
                return rslt;
            }, validate: {
                validator: 'required', 
                message: '공개여부 는 필수입력 입니다.'
            } },
            { name: "categoryNm", title: '카테고리', type: "text", width: 150, align: "left", editing: false },
            { name: "author", title: '강사명', type: "text", width: 100, align: "center" },
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
            { name: "requireYn", title: "필수강좌여부", type: 'select', items: [
                { Name: "전체", Id: "" },
                { Name: "Y", Id: "Y" },
                { Name: "N", Id: "N" }
            ],valueField: "Id", textField: "Name", width: 100, editing: true, validate: {
                validator: 'required', 
                message: '필수강좌여부 는 필수입력 입니다.'
            }, align: "center" },
            { type: 'control'}
        ]
    });


    $("#contentGrid").jsGrid({
        width: "100%",
        height: "200px",
        editing: true,
        sorting: true,
        paging: false,
        selecting: true,
        confirmDeleting: false,
        data: [],

        onItemUpdating: function(args) {
            if(!confirm('수정하시겠습니까?')) {
                args.cancel = true;
            }
        },

        onItemUpdated: function(args) {
            var rowKey = args.item.rowKey;
            var item = args.item;
            delete item['rowKey']; 
            
            fnUpdateDatabase('content', rowKey, item, function() {
                alert('수정되었습니다.');

                var data = $('#lectureGrid').jsGrid('option', 'data');
                var selectedRow = $("#lectureGrid").find('table tr.highlight').prevAll().length;

                fnRetrieveDetail(data[selectedRow]);
            });
        },

        onItemDeleting: function(args) {
            if(!confirm('삭제하시겠습니까?')) {
                args.cancel = true;
            }
        },

        onItemDeleted: function(args) {
            var rowKey = args.item.rowKey;
            
            fnDeleteDatabase('content', rowKey, function() {
                alert('삭제되었습니다.');

                var data = $('#lectureGrid').jsGrid('option', 'data');
                var selectedRow = $("#lectureGrid").find('table tr.highlight').prevAll().length;
                
                fnRetrieveDetail(data[selectedRow]);
            });
        },

        rowClick: function(args) {
            var arr = $('#contentGrid').jsGrid('option', 'data');
            var videoUrl = arr[args.itemIndex]['downloadURL'];
            var thumbnailUrl = arr[args.itemIndex]['thumbnail'];
            fnLoadVideo(videoUrl, thumbnailUrl);
            
            var $row = this.rowByItem(args.item);
            var selectedRow = $("#contentGrid").find('table tr.highlight');

            if (selectedRow.length) {
                selectedRow.toggleClass('highlight');
            };
            
            $row.toggleClass("highlight");
        },

        fields: [
            {
                itemTemplate: function(_, item) {
                    return $("<input>").attr("type", "checkbox")
                            .addClass('selectionCheckbox')
                            .prop("checked", $.inArray(item, selectedItemsContent) > -1)
                            //.prop('disabled', (item.rowKey == 'REQUIRED'))
                            .on("change", function () {
                                $(this).is(":checked") ? selectItem('content', item) : unselectItem('content', item);
                            });
                },
                align: "center",
                width: '30px'
            },
            { name: "thumbnail", title: '썸네일', width: 80, editing: false, align: "center", cellRenderer: function(item, value) {
                var rslt = $("<td>").addClass("jsgrid-cell");
                var img = $('<img onerror="this.src=\'/img/UPLOADING.png\'"/>');
                
                $(img).css('width', '60px');
                $(img).css('height', '45px');
                $(img).attr('src', item);
                $(rslt).append(img);
                
                return rslt;
            }, editTemplate: function(item, value) {
                
                var img = $('<img onerror="this.src=\'/img/UPLOADING.png\'"/>');
                
                $(img).css('width', '60px');
                $(img).css('height', '45px');
                $(img).attr('src', item);
                
                return img;
            } },
            { name: "title", title: '강의명', type: "text", width: 200, align: "left", cellRenderer: function(item, value) {
                var rslt = $("<td>").addClass("jsgrid-cell");
                var aLink = $("<a>");
                $(aLink).attr('href', '#');
                $(aLink).text(item);

                (function(value) {

                    $(aLink).on('click', function(e) {

                        e.preventDefault();

                        var data = $('#lectureGrid').jsGrid('option', 'data');
                        var selectedRow = $("#lectureGrid").find('table tr.highlight').prevAll().length;
                        var lectureId = data[selectedRow]['rowKey'];
                
                        
                        fnGo('/view/updateContent.html', {
                            'searchRequireYn' : $('#searchRequireYn').val(),
                            'searchCategory' : $('#searchCategory').val(),
                            'searhRelatedTag': $('#searhRelatedTag').val(),
                            'searchTitle': $('#searchTitle').val(),
                            'lectureId': lectureId,
                            'rowKey': value['rowKey']
                        });
                    });

                }(value));

                $(rslt).append(aLink);
                
                return rslt;
            } },
            { name: "seq", title: '정렬순서', type: "number", width: 50, align: "right" },
            { type: 'control' }
        ]
    });
    /** end of grid ***********************/


    $('#btnSearch').on('click', function(e) {
        $("#contentGrid").jsGrid("option", "data", []);
        fnRetrieve();
    });


    $('#btnAdd').on('click', function(e) {

        e.preventDefault();

        fnGo('/view/registerLecture.html', {
            'searchRequireYn' : $('#searchRequireYn').val(),
            'searchCategory' : $('#searchCategory').val(),
            'searchRelatedTag': $('#searchRelatedTag').val(),
            'searchTitle': $('#searchTitle').val()
        });
    });


    //행삭제 버튼
    $('#btnDel').on('click', function(e) {
        e.preventDefault();

        if(selectedItemsLecture.length == 0) {
            alert('선택된 데이터가 없습니다.');
            return false;
        }/* else {
            for(var i=0; i<selectedItemsLecture.length; i++) {
                var item = selectedItemsLecture[i];

                if(item['contentCnt'] > 0) {
                    alert('강의가 등록된 강좌는 삭제할 수 없습니다.');
                    return false;
                }
            }
        } */

        if(confirm("삭제하시겠습니까?")) {
            removeCheckedRows('lecture', function() {
                alert('삭제되었습니다.');
                fnRetrieve();
            });
        }
    });


    /** start of component ***********************/
    $('#btnAddVideo').on('click', function(e) {

        e.preventDefault();

        var data = $('#lectureGrid').jsGrid('option', 'data');
        var selectedRow = $("#lectureGrid").find('table tr.highlight').prevAll().length;
        var lectureId = data[selectedRow]['rowKey'];


        fnGo('/view/registerContent.html', {
            'searchRequireYn' : $('#searchRequireYn').val(),
            'searchCategory' : $('#searchCategory').val(),
            'searchRelatedTag': $('#searchRelatedTag').val(),
            'searchTitle': $('#searchTitle').val(),
            'lectureId': lectureId
        });
    });


    $('#btnDelVideo').on('click', function(e) {

        e.preventDefault();

        if(selectedItemsContent.length == 0) {
            alert('선택된 데이터가 없습니다.');
            return false;
        }

        if(confirm("삭제하시겠습니까?")) {
            removeCheckedRows('content', function() {
                alert('삭제되었습니다.');

                var data = $('#lectureGrid').jsGrid('option', 'data');
                var selectedRow = $("#lectureGrid").find('table tr.highlight').prevAll().length;

                fnRetrieveDetail(data[selectedRow]);
            });
        }
    });
    /** end of component ***********************/


    /** start of function ***********************/
    var selectedItemsLecture = [];
    var selectedItemsContent = [];
 
    function selectItem(option, item) {
        if(option == 'lecture') {
            selectedItemsLecture.push(item);
        }else {
            selectedItemsContent.push(item);
        }
    };

    function unselectItem(option, item) {
        if(option == 'lecture') {
            selectedItemsLecture = $.grep(selectedItems, function(i) {
                return i !== item;
            });
        }else {
            selectedItemsContent = $.grep(selectedItems, function(i) {
                return i !== item;
            });
        }
    }


    //체크된 건들 삭제
    function removeCheckedRows(option, callback) {
        var selectedItems = (option == 'lecture') ? selectedItemsLecture : selectedItemsContent;

        for(var i=0; i<selectedItems.length; i++) {
            var item = selectedItems[i];
            var rowKey = item['rowKey'];
            fnDeleteDatabase(option, rowKey, null)
        }

        if(option == 'lecture') {
            selectedItemsLecture = [];
            selectedItemsContent = [];
        }else {
            selectedItemsContent = [];
        }

        if(callback != null && callback != undefined) {
            callback();
        }
    }


    //삭제
    function fnDeleteDatabase(option, rowKey, callback) {

        switch (option) {
            case 'lecture':
                    parent.database.ref('/' + compCd + '/lecture/' + rowKey + '/').remove().then(function onSuccess(res) {
                        if(callback != null && callback != undefined) {
                            callback();
                        }
                    }).catch(function onError(err) {
                        console.log("ERROR!!!! " + err);
                    });
                break;

            case 'content':
                    var data = $('#lectureGrid').jsGrid('option', 'data');
                    var selectedRow = $("#lectureGrid").find('table tr.highlight').prevAll().length;
                    var lectureId = data[selectedRow]['rowKey'];
                    console.log(lectureId);

                    parent.database.ref('/' + compCd + '/lecture/' + lectureId + '/videos/' + rowKey).remove().then(function onSuccess(res) {
                        if(callback != null && callback != undefined) {
                            callback();
                        }
                    }).catch(function onError(err) {
                        console.log("ERROR!!!! " + err);
                    });
                break;
        }

        
    }


    //신규
    function fnCreate(item, callback) {
        parent.database.ref( '/' + compCd + '/lecture/').push({
            'title': item['title'],
            'requireYn': item['requireYn']
        }).then(function onSuccess(res) {
            if(callback != null && callback != undefined) {
                callback();
            }
        }).catch(function onError(err) {
            console.log("ERROR!!!! " + err);
        });
    }


    //combo 구성
    function fnGetCommonCmb(option, selector, defaultValue) {

        $('' + selector).html('');
        $('' + selector).html('<option value="">전체</option>');

        switch(option) {
            case 'tag':
                parent.database.ref('/' + compCd + '/tags/').once('value')
                .then(function (snapshot) {
                    var tagArr = snapshot.val();
                    var optionArr = [];
                
                    $.each(tagArr, function(idx, tagObj) {
                        var newOption = $('<option></option>');
                        $(newOption).attr('value', tagArr[idx].value);
                        $(newOption).text(tagArr[idx].value);

                        if(tagArr[idx].value == defaultValue) {
                            $(newOption).attr('selected', 'selected');
                        }

                        $(''+selector).append($(newOption));
                    });

                    $(''+selector).selectpicker();
                });    
                break;


            case 'category':
                    parent.database.ref('/' + compCd + '/categories/').once('value')
                    .then(function (snapshot) {
                        var catArr = snapshot.val();
                        var optionArr = [];
                    
                        $.each(catArr, function(idx, catObj) {
                            var newOption = $('<option></option>');
                            $(newOption).attr('value', idx);
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


    //수정
    function fnUpdateDatabase(option, rowKey, paramObj, callback) {

        switch(option) {
            case 'lecture':
                    parent.database.ref('/' + compCd + '/lecture/' + rowKey + '/').update(paramObj).then(function onSuccess(res) {
                        if (callback != null && callback != undefined) {
                            callback();
                        }
                    }).catch(function onError(err) {
                        console.log("ERROR!!!! " + err);
                    });
                break;

            case 'content':
                    var data = $('#lectureGrid').jsGrid('option', 'data');
                    var selectedRow = $("#lectureGrid").find('table tr.highlight').prevAll().length;
                    var lectureId = data[selectedRow]['rowKey'];

                    console.log(paramObj);

                    parent.database.ref('/' + compCd + '/lecture/' + lectureId + '/videos/' + rowKey + '/').update(paramObj).then(function onSuccess(res) {
                        if (callback != null && callback != undefined) {
                            callback();
                        }
                    }).catch(function onError(err) {
                        console.log("ERROR!!!! " + err);
                    });
                break;
        }
    }


    //video load
    function fnLoadVideo(videoUrl, thumbnailUrl) {
        var video = document.getElementById('video');
        video.pause();

        var source = document.createElement('source');
        source.type = 'video/mp4';
        source.src = videoUrl;

        video.innerHTML = '';
        video.poster = thumbnailUrl;
        video.appendChild(source);

        video.load();
    }


    function fnInit() {

        $('#searchRequireYn').selectpicker();

        var searchParam = getParams();
        
        if(Object.keys(searchParam).length > 0) {
            $('#searchRequireYn').val(searchParam['searchRequireYn']);
            $('#searchRequireYn').selectpicker('refresh');
            $('#searchTitle').val(searchParam['searchTitle']);
            
            fnGetCommonCmb('tag', '#searchRelatedTag', searchParam['searchRelatedTag']);
            fnGetCommonCmb('category', '#searchCategory', searchParam['searchCategory']);

            fnRetrieve({
                searchRequireYn: searchParam['searchRequireYn'],
                searchCategory: searchParam['searchCategory'],
                searchTitle: searchParam['searchTitle'],
                searchRelatedTag: searchParam['searchRelatedTag'],
                focusRowKey: isEmpty(searchParam['rowKey']) ? '' : searchParam['rowKey']
            });
        }else {
            fnGetCommonCmb('tag', '#searchRelatedTag');
            fnGetCommonCmb('category', '#searchCategory');
            fnRetrieve();
        }

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


    function getParams() {
        var param = {};
     
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


    function fnRetrieve(searchParam) {
        
        selectedItemsLecture = [];
        selectedItemsContent = [];
        
        var searchCompany = compCd;
        var searchCategory = $('#searchCategory').val() || '';
        var searchTitle = $('#searchTitle').val() || '';
        var searchRelatedTag = $('#searchRelatedTag').val() || '';
        var searchRequireYn = $('#searchRequireYn').val() || '';
        var focusRowKey = '';
        var focusIdx = 0;

        if(!isEmpty(searchParam)) {
            searchRequireYn = searchParam['searchRequireYn'] || '';
            searchCat = searchParam['searchCategory'] || '';
            searchTag = searchParam['searchRelatedTag'] || '';
            searchTitle = searchParam['searchTitle'] || '';
            focusRowKey = searchParam['focusRowKey'] || '';
        }else {
            searchRequireYn = $('#searchRequireYn').val() || '';
            searchCat = $('#searchCategory').val() || '';
            searchTag = $('#searhRelatedTag').val() || '';
            searchTitle = $('#searchTitle').val() || '';
        }


        window.FakeLoader.showOverlay();

        parent.database.ref('/'+ searchCompany+'/lecture').once('value').then(function(snapshot) {
    
            var catArr = snapshot.val();
            var rsltArr = [];

            var cnt = 0;

            $.each(catArr, function(idx, catObj) {
                if(
                    ((searchTitle == '') || (catObj['title'].toLowerCase().indexOf(searchTitle.toLowerCase()) > -1)) &&
                    (searchRequireYn == '' || searchRequireYn == catObj['requireYn']) &&
                    (searchRelatedTag == '' || $.inArray(searchRelatedTag, catObj['tags'].split(' ')) > -1) &&
                    ((searchCategory == '') || searchCategory == catObj['categoryId'])
                    
                ) {
                    var contentObj = catObj['videos'] || {};
    
                    catObj['rowKey'] = idx;
                    if(idx == focusRowKey) {
                        console.log('YES');
                        focusIdx = cnt;
                    }

                    cnt++;

                    rsltArr.push(catObj);
                }
            });

            $("#lectureGrid").jsGrid("option", "data", rsltArr);

            window.FakeLoader.hideOverlay();

            $('#lectureGrid').find('tbody > tr:eq('+ focusIdx +')').click(); 
            $('#lectureGrid').find('tbody > tr:eq('+ focusIdx +')').focus();
        });
    }


    //상세조회
    function fnRetrieveDetail(item) {
        
        fnLoadVideo('' , '');
        selectedItemsContent = [];
        
        var searchCompany = compCd;

        window.FakeLoader.showOverlay();

        parent.database.ref('/'+ searchCompany+'/lecture/'+ item['rowKey'] + '/videos').once('value').then(function(snapshot) {
    
            var catArr = snapshot.val();
            var rsltArr = [];

            $.each(catArr, function(idx) {

                var catObj = catArr[idx];

                catObj['rowKey'] = idx;
                rsltArr.push(catObj);
            });

            //seq 기준 오름차순 정렬
            rsltArr.sort(function(a, b) {
                return a.seq - b.seq;
            });

            $("#contentGrid").jsGrid("option", "data", rsltArr);
            $('#contentGrid').find('tr.jsgrid-row:eq(0)').click(); //첫번째 row click

            window.FakeLoader.hideOverlay();
        });

    }
    /** end of function ***********************/


    resizeFrame();
    fnInit();
 
});