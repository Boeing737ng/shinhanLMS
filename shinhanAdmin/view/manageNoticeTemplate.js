

$(document).ready(function () {

    var userObj = JSON.parse(window.sessionStorage.getItem('userInfo'));
    var compCd = userObj['compCd'];


    /** start of components ***********************/
    window.FakeLoader.init();


    $('[data-toggle="tooltip"]').tooltip();


    $('#btnGuide').on('click', function(e) {

        //modal-guide
        $('#modal-guide').modal();
    });


    //행추가 버튼
    $('#btnAdd').on('click', function(e) {
        e.preventDefault();
        
        $('#grid').find('tr').removeClass('highlight');
        fnClearDetail();
        
        $('#detailText').prop('disabled', false);
        $('#templateNm').prop('disabled', false);
        $('#btnSaveDetail').show();

        $('#templateNm').focus();
    });


    //행삭제 버튼
    $('#btnDel').on('click', function(e) {
        e.preventDefault();

        if(selectedItems.length == 0) {
            alert('선택된 데이터가 없습니다.');
            args.cancel = true;
            return false;
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


    //저장 버튼
    $('#btnSaveDetail').on('click', function(e) {

        e.preventDefault();


        if(isEmpty($('#templateNm').val())) {
            alert('템플릿명 은(는) 필수입력 입니다.');
            $('#templateNm').focus();
            return;
        }else if(isEmpty($('#detailText').val())) {
            alert('내용 은(는) 필수입력 입니다.');
            $('#detailText').focus();
            return;
        }


        if(!confirm('저장하시겠습니까?')) {
            return;
        }


        var data = $('#grid').jsGrid('option', 'data');
        var rowKey;
        var selectedRow = $("#grid").find('table tr.highlight').prevAll().length;

        if($("#grid").find('table tr.highlight').length == 0) {
            rowKey = null;
        }else {
            rowKey = data[selectedRow]['rowKey'];
        }

        fnSave(rowKey, {
            detailText: $('#detailText').val() || '',
            templateNm: $('#templateNm').val() || ''
        }, function() {
            alert('저장되었습니다.');
            fnRetrieve();
        });
    });
    /** end of components ***********************/


    /** start of grid ***********************/
    $("#grid").jsGrid({
        width: "100%",
        height: "581px",
        sorting: true,
        paging: false,
        data: [],

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
            var $row = this.rowByItem(args.item);
            var selectedRow = $("#grid").find('table tr.highlight');

            if (selectedRow.length) {
                selectedRow.toggleClass('highlight');
            };
            
            $row.toggleClass("highlight");

            fnRetrieveDetail(args.item);
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
            { name: "templateNm", title: '템플릿명', type: "text", width: 200, editing: false, align: "left" }

        ]
    });
    

    //조회
    function fnRetrieve() {
    
        fnClearDetail();
        selectedItems = [];
       
        var searchTitle = $('#title').val() || '';
        var searchDate = $('#date').val() || '';

        window.FakeLoader.showOverlay();


        parent.database.ref('/notieTemplate').once('value').then(function (snapshot) {   //log.console(searchㅅTitle)

            var catArr = snapshot.val();
            var rsltArr = [];


            $.each(catArr, function (idx, studyObj) {

                if (
                    ((searchTitle == '') || (studyObj['title'].indexOf(searchTitle) > -1)) &&
                    ((searchDate == '') || moment(studyObj['date'], 'YYYYMMDD').format('YYYYMMDD') == moment(searchDate, 'YYYY-MM-DD').format('YYYYMMDD')) 

                ) {
                    studyObj['rowKey'] = idx;
                    rsltArr.push(studyObj);
                }
            });

            $("#grid").jsGrid("option", "data", rsltArr);
            $('#grid').find('tr.jsgrid-row:eq(0)').click(); //첫번째 row click

            window.FakeLoader.hideOverlay();

        });
    }


    //상세 조회
    function fnRetrieveDetail(item) {
        //fnClearDetail();
        $('#templateNm').val(item['templateNm']);
        $('#detailText').val(item['detailText']);

        $('#detailText').prop('disabled', false);
        $('#templateNm').prop('disabled', false);
        $('#btnSaveDetail').show();
    }


    //상세 폼 삭제
    function fnClearDetail() {
        $('#detailText').val('');
        $('#templateNm').val('');

        $('#detailText').prop('disabled', true);
        $('#templateNm').prop('disabled', true);
        $('#btnSaveDetail').hide();
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


    //저장
    function fnSave(rowKey, paramObj, callback) {

        if(isEmpty(rowKey)) {//신규

            parent.database.ref('/notieTemplate/').push(paramObj).then(function onSuccess(res) {
                if(callback != null && callback != undefined) {
                    callback();
                }
            }).catch(function onError(err) {
                console.log("ERROR!!!! " + err);
            });

        }else {//수정

            parent.database.ref('/notieTemplate/' + rowKey + '/').update(paramObj).then(function onSuccess(res) {
                if(callback != null && callback != undefined) {
                    callback();
                }
            }).catch(function onError(err) {
                console.log("ERROR!!!! " + err);
            });

        }

    }


    //삭제
    function fnDeleteDatabase(rowKey, callback) {

        parent.database.ref('/notieTemplate/' + rowKey + '/').remove().then(function onSuccess(res) {
            if(callback != null && callback != undefined) {
                callback();
            }
        }).catch(function onError(err) {
            console.log("ERROR!!!! " + err);
        });
    }
    /** start of grid ***********************/


    resizeFrame();
    fnRetrieve();

});