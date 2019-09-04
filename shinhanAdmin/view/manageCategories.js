
$(document).ready(function () {

    window.FakeLoader.init( );
    var userObj = JSON.parse(window.sessionStorage.getItem('userInfo'));
    var compCd = userObj['compCd'];
    var compNm = userObj['compNm'];

    /** start of grid ***********************/
    $("#grid").jsGrid({
        width: "100%",
        height: "200px",
        //editing: true,
        inserting: true,
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

        rowClick: function(args) {
            var $row = this.rowByItem(args.item),
            selectedRow = $("#grid").find('table tr.highlight');

            if (selectedRow.length) {
                selectedRow.toggleClass('highlight');
            };
            
            $row.toggleClass("highlight");

            fnRetrieveDetail(args.item);
            
            /* if(this.editing) {
                this.editItem($(args.event.target).closest("tr"));
            } */
        },

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
            { name: "title", title: '카테고리명', type: "text", width: 200, align: "left", validate: {
                validator: 'required', 
                message: '공개여부 는 필수입력 입니다.'
            } },
            /*{ name: "requireYn", title: '필수강좌여부', type: "select", width: 50, align: "center", type: 'select', items: [
                { Name: "전체", Id: "" },
                { Name: "Y", Id: "Y" },
                { Name: "N", Id: "N" }
            ],valueField: "Id", textField: "Name", inserting: true, validate: {
                validator: 'required', 
                message: '필수강좌여부 는 필수입력 입니다.'
            }, align: "center" },*/
            { name: "contentCnt", title: '등록 강좌수', type: "number", width: 50, align: "right", inserting: false, editing: false },
            { type: "control", editButton: false, deleteButton: false } //edit control
        ]
    });


    $("#detailGrid").jsGrid({
        width: "100%",
        height: "300px",
        //editing: true,
        sorting: true,
        paging: false,
        selecting: true,
        data: [],

        fields: [
            { name: "title", title: '강좌명', type: "text", width: 200, align: "left" },
            { name: "author", title: '강사명', type: "text", width: 100, align: "left" }
        ]
    });


    $('#btnSearch').on('click', function(e) {
        $("#detailGrid").jsGrid("option", "data", []);
        fnRetrieve();
    });


    //행삭제 버튼
    $('#btnDel').on('click', function(e) {
        e.preventDefault();

        if(selectedItems.length == 0) {
            alert('선택된 데이터가 없습니다.');
            args.cancel = true;
            return false;
        }else {
            for(var i=0; i<selectedItems.length; i++) {
                var item = selectedItems[i];

                if(item['contentCnt'] > 0) {
                    alert('컨텐츠가 등록된 카테고리는 삭제할 수 없습니다.');
                    args.cancel = true;
                    return false;
                }
            }
        }

        if(confirm("삭제하시겠습니까?")) {
            removeCheckedRows(function() {
                alert('삭제되었습니다.');
                fnRetrieve();
            });
        }
    });


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


    //삭제
    function fnDeleteDatabase(rowKey, callback) {

        parent.database.ref('/' + compCd + '/categories/' + rowKey + '/').remove().then(function onSuccess(res) {
            if(callback != null && callback != undefined) {
                callback();
            }
        }).catch(function onError(err) {
            console.log("ERROR!!!! " + err);
        });
    }


    //신규
    function fnCreate(item, callback) {
        parent.database.ref( '/' + compCd + '/categories/').push({
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


    function fnRetrieve() {
        
        selectedItems = [];
        
        var searchCompany = compCd;
        var searchCategory = $('#searchCategory').val() || '';


        window.FakeLoader.showOverlay();

        parent.database.ref('/'+ searchCompany+'/categories').once('value').then(function(snapshot) {
    
            var catArr = snapshot.val();
            var rsltArr = [];

            $.each(catArr, function(idx, catObj) {

                var catName = catObj['title'] || '';

                if(searchCategory == '' || catName.indexOf(searchCategory) > -1) {
                    var contentObj = catObj['videos'] || {};
                    var contentCnt = Object.keys(contentObj).length;
    
                    catObj['rowKey'] = idx;
                    catObj['contentCnt'] = contentCnt;
                    rsltArr.push(catObj);
                }
            });

            $("#grid").jsGrid("option", "data", rsltArr);

            window.FakeLoader.hideOverlay();

            $('#grid').find('tr.jsgrid-row:eq(0)').click(); //첫번째 row click
        });
    }


    //상세조회
    function fnRetrieveDetail(item) {
        var searchCompany = compCd;

        window.FakeLoader.showOverlay();

        parent.database.ref('/'+ searchCompany+'/categories/'+ item['rowKey'] + '/videos').once('value').then(function(snapshot) {
    
            var catArr = snapshot.val();
            var rsltArr = [];

            $.each(catArr, function(idx) {

                var catObj = catArr[idx];
                var catName = catObj['title'];
                var author = catObj['author'];

                var contentCnt = Object.keys(catObj).length;

                catObj['rowKey'] = idx;
                catObj['contentCnt'] = contentCnt;
                rsltArr.push(catObj);
            });

            $("#detailGrid").jsGrid("option", "data", rsltArr);

            window.FakeLoader.hideOverlay();
        });

    }


    resizeFrame();
    fnRetrieve();
 
});