

$(document).ready(function () {

    var userObj = JSON.parse(window.sessionStorage.getItem('userInfo'));
    var compCd = userObj['compCd'];

    
    /** start of components ***********************/
    window.FakeLoader.init( );


    //검색 버튼
    $('#btnSearch').on('click', function(e) {
        e.preventDefault();
        fnRetrieve();
    });


    //행추가 버튼
    $('#btnAdd').on('click', function(e) {
        e.preventDefault();

        fnGo('/view/registerContent.html', {
            'searchRequireYn' : $('#searchRequireYn').val(),
            'searchCategory' : $('#searchCategory').val(),
            'searhRelatedTag': $('#searhRelatedTag').val(),
            'searchTitle': $('#searchTitle').val()
        });
    });


    //행삭제 버튼
    $('#btnDel').on('click', function(e) {
        e.preventDefault();

        if(selectedItems.length == 0) {
            alert('선택된 데이터가 없습니다.');
            return false;
        }

        if(confirm("삭제하시겠습니까?")) {
            removeCheckedRows(function() {
                alert('삭제되었습니다.');
                fnRetrieve();
            });
        }
    });
    /** end of components *************************/


    /** start of grid ***********************/
    $("#grid").jsGrid({
        width: "100%",
        height: "500px",
        editing: true,
        sorting: true,
        paging: false,
        selecting: true,
        data: [],

        onItemUpdating: function(args) {
            if(!confirm('수정하시겠습니까?')) {
                args.cancel = true;
            }
        },

        onItemUpdated: function(args) { //수정
            var rowKey = args.item.rowKey;
            var item = args.item;
            delete item['rowKey']; 
            
            fnUpdateDatabase(rowKey, item, function() {
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
            
            fnDeleteDatabase(rowKey, function() {
                alert('삭제되었습니다.');
                fnRetrieve();
            });
        },

        rowClick: function(args) {
            //showDetailsDialog("Edit", args.item);
            var arr = $('#grid').jsGrid('option', 'data');
            var videoUrl = arr[args.itemIndex]['downloadURL'];
            fnLoadVideo(videoUrl);

            var $row = this.rowByItem(args.item),
            selectedRow = $("#grid").find('table tr.highlight');

            if (selectedRow.length) {
                selectedRow.toggleClass('highlight');
            };
            
            $row.toggleClass("highlight");
            
            /* if(this.editing) {
                this.editItem($(args.event.target).closest("tr"));
            } */
        },

        rowDoubleClick: function(args) {
            var arr = $('#grid').jsGrid('option', 'data');
            
            fnGo('/view/updateContent.html', {
                'searchRequireYn' : $('#searchRequireYn').val(),
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
            { name: "author", title: '강사명', type: "text", width: 120, editing: false, align: "center" },
            { name: "categoryNm", title: "카테고리", type: 'text', width: 200, editing: false, align: "left" },
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
            { name: "requireYn", title: "필수강좌여부", type: 'select', items: [
                { Name: "전체", Id: "" },
                { Name: "Y", Id: "Y" },
                { Name: "N", Id: "N" }
            ],valueField: "Id", textField: "Name", width: 100, editing: true, validate: {
                validator: 'required', 
                message: '필수강좌여부 는 필수입력 입니다.'
            }, align: "center" },
            { type: "control" } //edit control
        ]
    });


    
    
    
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
    /** end of grid *************************/


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

    
    //조회
    function fnRetrieve(searchParam) {
        
        var searchRequireYn;
        var searchCat;
        var searchTag;
        var searchTitle;

        if(!isEmpty(searchParam)) {
            searchRequireYn = searchParam['searchRequireYn'] || '';
            searchCat = searchParam['searchCategory'] || '';
            searchTag = searchParam['searchRelatedTag'] || '';
            searchTitle = searchParam['searchTitle'] || '';
        }else {
            searchRequireYn = $('#searchRequireYn').val() || '';
            searchCat = $('#searchCategory').val() || '';
            searchTag = $('#searhRelatedTag').val() || '';
            searchTitle = $('#searchTitle').val() || '';
        }

        window.FakeLoader.showOverlay();
        

        parent.database.ref('/' + compCd + '/videos/').once('value').then(function(snapshot) {

            var catArr = snapshot.val();
            var rsltArr = [];
            
            $.each(catArr, function(idx, catObj) {
                var trgtTagArr = (catObj['tags'] || '').split(' ');

                if( 
                    ((searchRequireYn == '') || (searchRequireYn == catObj['requireYn'])) &&
                    ((searchCat == '') || (searchCat == catObj['categoryId'])) &&
                    ((searchTag == '') || (trgtTagArr.indexOf(searchTag) > -1)) &&
                    ((searchTitle == '') || (catObj['title'].indexOf(searchTitle)) > -1)
                ) {
                    catObj['rowKey'] = idx;
                    rsltArr.push(catObj);
                }
            });

            $("#grid").jsGrid("option", "data", rsltArr);
            window.FakeLoader.hideOverlay();
        });
    }


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
            fnDeleteDatabase(rowKey, null)
        }

        if(callback != null && callback != undefined) {
            callback();
        }

        selectedItems = [];
    }


    function getCheckedRows() {
        var cnt = $('#grid').find('input[type=checkbox].selectionCheckbox').length;
        return cnt;
    }


    //삭제
    function fnDeleteDatabase(rowKey, callback) {

        parent.database.ref('/' + compCd + '/videos/' + rowKey + '/').remove().then(function onSuccess(res) {
            if(callback != null && callback != undefined) {
                callback();
            }
        }).catch(function onError(err) {
            console.log("ERROR!!!! " + err);
        });
    }


    //수정
    function fnUpdateDatabase(rowKey, paramObj, callback) {

        parent.database.ref('/' + compCd + '/videos/' + rowKey + '/').update({
            downloadURL: paramObj['downloadURL'],
            author: paramObj['author'],
            categoryId: paramObj['categoryId'],
            categoryNm: paramObj['categoryNm'],
            tags: paramObj['tags'],
            description: paramObj['description'],
            date: paramObj['date'],
            thumbnail: paramObj['thumbnail'],
            title: paramObj['title'],
            requireYn: paramObj['requireYn']
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
                    
                        console.log(catArr)
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


    function fnInit() {

        $('#searchRequireYn').selectpicker();

        var searchParam = getParams();
        
        if(Object.keys(searchParam).length > 0) {
            $('#searchRequireYn').val(searchParam['searchRequireYn']);
            $('#searchRequireYn').selectpicker('refresh');
            
            //$('#searchCategory').val(searchParam['searchCategory']);
            //$('#searchCategory').selectpicker('refresh');
            
            $('#searchTitle').val(searchParam['searchTitle']);
            
            fnGetCommonCmb('tag', '#searhRelatedTag', searchParam['searhRelatedTag']);
            fnGetCommonCmb('category', '#searchCategory', searchParam['searchCategory']);

            fnRetrieve({
                searchRequireYn: searchParam['searchRequireYn'],
                searchCategory: searchParam['searchCategory'],
                searchTitle: searchParam['searchTitle'],
                searchRelatedTag: searchParam['searhRelatedTag'] 
            });
        }else {
            fnGetCommonCmb('tag', '#searhRelatedTag');
            fnGetCommonCmb('category', '#searchCategory');
            fnRetrieve();
        }

    }


    //ifame height resize
    resizeFrame();
    fnInit();

});