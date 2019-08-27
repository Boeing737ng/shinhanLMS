

$(document).ready(function () {

    /** start of components ***********************/
    window.FakeLoader.init();

    $('#searchOpenYn').selectpicker();
    $('#searchCategory').selectpicker();
    $('#searhRelatedTag').selectpicker();
    $('#searchCompany').selectpicker();
    $('#searchRegDate').datepicker();
    $('#date').datepicker();

    $.datepicker.setDefaults({
        dateFormat: 'yy-mm-dd' //Input Display Format 변경
    });


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



    /** start of grid ***********************/
    $("#grid").jsGrid({
        width: "100%",
        height: "300px",
        sorting: true,
        paging: false,
        data: [],
        //data: clients,

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
            { name: "title", title: '제목', type: "text", width: 200, editing: false, align: "left" },
            { name: "writor", title: "작성자", type: 'text', width: 100, editing: false, align: "left" },
            {
                name: "date", title: "등록일자", type: 'text', width: 100, editing: false, align: "center", cellRenderer: function (item, value) {
                    var rslt = $("<td>").addClass("my-row-custom-class");
                    var date = moment(item, 'YYYYMMDDHHmmss').format('YYYY-MM-DD');
                    $(rslt).append(date);
                    return rslt;
                }
            },
            { name: "daterange", title: "게시기간", type: 'text', width: 150, editing: false, align: "center" },
            { name: "releaseYn", title: "공개여부", type: 'text', width: 100, editing: false, align: "center" }

        ]
    });

    //조회
    function fnRetrieve(callback) {
        var searchTitle = $('#title').val() || '';
        var searchWritor = $('#writor').val() || '';
        var searchDate = $('#date').val() || '';

        window.FakeLoader.showOverlay();


        firebase.database().ref('/' + '신한은행' + '/notie').once('value').then(function (snapshot) {   //log.console(searchㅅTitle)

            var catArr = snapshot.val();
            var rsltArr = [];

            $.each(catArr, function (idx, studyObj) {

                if (
                    ((searchTitle == '') || (studyObj['writor'].indexOf(search) > -1))
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

        firebase.database().ref('/' + '신한은행' + '/notie/' + rowKey + '/').remove().then(function onSuccess(res) {
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