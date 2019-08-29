

$(document).ready(function () {

    var userObj = JSON.parse(window.sessionStorage.getItem('userInfo'));
    var compCd = userObj['compCd'];


    /** start of components ***********************/
    window.FakeLoader.init();

    $('#date').datepicker({
        dateFormat: 'yy-mm-dd' //Input Display Format 변경
    });

    //fnGetCommonCmb('company', '#searchCompany');

/*     $.datepicker.setDefaults({
        dateFormat: 'yy-mm-dd' //Input Display Format 변경
    }); */


    //행추가 버튼 -> 페이지 이동
    $('#btnAdd').on('click', function(e) {
        e.preventDefault();
        window.location.href = "/view/registerNotice.html";
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
    

    //검색 버튼
    $('#btnSearch').on('click', function (e) {
        e.preventDefault();
        $('#grid1').jsGrid("option", "data", []);
        fnRetrieve();
    });
    /** end of components ***********************/


    /** start of grid ***********************/
    $("#grid").jsGrid({
        width: "100%",
        height: "500px",
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
            
            fnGo('/view/updateNotice.html', {
                'searchTitle': $('#searchTitle').val(),
                'searchDate': $('#date').val(),
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
                width: 15
            },
            { name: "title", title: '제목', type: "text", width: 200, editing: false, align: "left" },
            { name: "writor", title: "작성자", type: 'text', width: 100, editing: false, align: "left" },
            {
                name: "date", title: "등록일자", type: 'text', width: 100, editing: false, align: "center", cellRenderer: function (item, value) {
                    var rslt = $("<td>").addClass("my-row-custom-class");
                    var date = moment(item, 'YYYYMMDDHHmmss').format('YYYY-MM-DD');
                    $(rslt).append(date);
                    return rslt;
                }
            }
        

        ]
    });

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
    
    //조회
    function fnRetrieve() {
        var searchTitle = $('#title').val() || '';
        var searchDate = $('#date').val() || '';

        window.FakeLoader.showOverlay();


        parent.database.ref('/' + compCd + '/notie').once('value').then(function (snapshot) {   //log.console(searchㅅTitle)

            var catArr = snapshot.val();
            var rsltArr = [];


            $.each(catArr, function (idx, studyObj) {

                if (
                    ((searchTitle == '') || (studyObj['title'].indexOf(searchTitle) > -1)) &&
                    ((searchDate == '') || moment(studyObj['date'], 'YYYYMMDD').format('YYYYMMDD') == moment(searchDate, 'YYYY-MM-DD').format('YYYYMMDD')) 

                ) {
                    var mbrCnt = Object.keys(studyObj['member'] || []).length + 1;
                    studyObj['participant'] = mbrCnt;
                    studyObj['rowKey'] = idx;
                    rsltArr.push(studyObj);
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


    //삭제
    function fnDeleteDatabase(rowKey, callback) {

        parent.database.ref('/' + compCd + '/notie/' + rowKey + '/').remove().then(function onSuccess(res) {
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

        switch (option) {
            case 'company':
                parent.database.ref('/company/').once('value')
                    .then(function (snapshot) {
                        var arr = snapshot.val();

                        $.each(arr, function (idx, val) {
                            var newOption = $('<option></option>');
                            $(newOption).attr('value', idx);
                            $(newOption).text(val);

                            if (idx == defaultValue) {
                                $(newOption).attr('selected', 'selected');
                            }

                            $('' + selector).append($(newOption));
                        });

                        $('' + selector).selectpicker();
                    });
                break;
        }
    }
    /** start of grid ***********************/




    resizeFrame();
    fnRetrieve();

});