

$(document).ready(function () {

    /** start of components ***********************/
    $('#searchOpenYn').selectpicker();
    $('#searchCategory').selectpicker();
    //$('#searhRelatedTag').selectpicker();

    $('#contentModal select.releaseYn').selectpicker();
    $('#contentModal select.category').selectpicker();

    fnGetCommonCmb('tag', '#searhRelatedTag');
    

    //검색 버튼
    $('#btnSearch').on('click', function(e) {
        e.preventDefault();
        fnRetrieve();
    });


    //행추가 버튼
    $('#btnAdd').on('click', function(e) {
        e.preventDefault();
        window.location.href = "/view/registerContent.html";
    });


    //행삭제 버튼
    $('#btnDel').on('click', function(e) {
        e.preventDefault();

        alert('TO DO');
        return;

        if(grid.getCheckedRows().length == 0) {
            alert('선택된 데이터가 없습니다.');
            return false;
        }

        if(confirm("삭제하시겠습니까?")) {
            alert('TO DO');
            //grid.removeCheckedRows();
        }
    });


    //저장 버튼
    $('#btnSave').on('click', function(e) {
        e.preventDefault();
        
        if(!grid.isModified()) {
            alert('저장할 데이터가 없습니다.');
            return false;
        }

        if(confirm('저장하시겠습니까?')) {
            var modifiedRecords = grid.getModifiedRows();
            console.log(modifiedRecords);
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
        },

        /* editRowRenderer: function(item, itemIndex) {
            console.log(item);
        }, */

        editRowRenderer: function(item, itemIndex) {
            var grid = this;
            var $nameEditor = $("<input>").attr("type", "text").attr("name", "FirstName").val(item.Name);

            var $updateButton = $("<input>").attr("type", "button").addClass("jsgrid-button jsgrid-update-button");
            var $cancelButton = $("<input>").attr("type", "button").addClass("jsgrid-button jsgrid-cancel-button");
            
						$updateButton.on("click", function() {
            	grid.updateItem(item, { Name: $nameEditor.val() });
            });

						$cancelButton.on("click", function() {
            	grid.cancelEdit();
            });

            return $("<tr>")
              .append($("<td>").append($nameEditor))
              .append($updateButton)
              .append($cancelButton);
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
            { name: "thumbnail", title: '썸네일', type: "text", width: 80, editing: false, align: "center", cellRenderer: function(item, value) {
                var rslt = $("<td>").addClass("my-row-custom-class");
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
                var rslt = $("<td>").addClass("my-row-custom-class");
                var div = $('<div></div>');
                $(rslt).append(div);

                var arr = item.split(' ');
                for(var i=0; i<arr.length; i++) {
                    $(div).append($('<span class="tag label label-info" style="margin-right:5px; display:inline-block;">'+arr[i]+'</span>'));
                }
                return rslt; 
              } },
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


    fnRetrieve();

    
    //조회
    function fnRetrieve() {
        var searchReleaseYn = $('#searchOpenYn').val() || '';
        var searchCat = $('#searchCategory').val() || '';
        var searchTag = $('#searhRelatedTag').val() || '';
        var searchTitle = $('#searchTitle').val() || '';

        firebase.database().ref('/videos/').once('value').then(function(snapshot) {

            var catArr = snapshot.val();
            var rsltArr = [];
            
            $.each(catArr, function(idx, catObj) {
                var trgtTagArr = catObj['tags'].split(' ');

                if( 
                    ((searchReleaseYn == '') || (searchReleaseYn == catObj['releaseYn'])) &&
                    ((searchCat == '') || (searchCat == catObj['category'])) &&
                    ((searchTag == '') || (trgtTagArr.indexOf(searchTag) > -1)) &&
                    ((searchTitle == '') || (catObj['title'].indexOf(searchTitle)) > -1)
                ) {
                    catObj['rowKey'] = idx;
                    rsltArr.push(catObj);
                }
            });

            $("#grid").jsGrid("option", "data", rsltArr);
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


    function deleteSelectedItems() {
        if(!selectedItems.length || !confirm("Are you sure?"))
            return;
 
        deleteClientsFromDb(selectedItems);
 
        var $grid = $("#jsGrid");
        $grid.jsGrid("option", "pageIndex", 1);
        $grid.jsGrid("loadData");
 
        selectedItems = [];
    }


    //삭제
    function fnDeleteDatabase(rowKey, callback) {

        firebase.database().ref('videos/' + rowKey + '/').remove().then(function onSuccess(res) {
            if(callback != null && callback != undefined) {
                callback();
            }
        }).catch(function onError(err) {
            console.log("ERROR!!!! " + err);
        });
    }


    //수정
    function fnUpdateDatabase(rowKey, paramObj, callback) {

        firebase.database().ref('videos/' + rowKey + '/').update({
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


    //combo 구성
    function fnGetCommonCmb(option, selector) {

        $('' + selector).html('');
        $('' + selector).html('<option value="">전체</option>');

        switch(option) {
            case 'tag':
                firebase.database().ref('/tags/').once('value')
                .then(function (snapshot) {
                    var tagArr = snapshot.val();
                    var optionArr = [];
                
                    $.each(tagArr, function(idx, tagObj) {
                        var newOption = $('<option></option>');
                        $(newOption).attr('value', tagArr[idx].value);
                        $(newOption).text(tagArr[idx].value);
                        $(''+selector).append($(newOption));
                    });

                    $(''+selector).selectpicker();
                });    
                break;


            case 'category':

                break; 
        }
    }


    //ifame height resize
    resizeFrame();

});