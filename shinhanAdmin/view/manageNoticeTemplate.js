

$(document).ready(function () {

    var userObj = JSON.parse(window.sessionStorage.getItem('userInfo'));
    var compCd = userObj['compCd'];


    /** start of components ***********************/
    window.FakeLoader.init();


    //행추가 버튼 -> 페이지 이동
    $('#btnAdd').on('click', function(e) {
        e.preventDefault();
        
        fnGo('/view/registerNotice.html', {
            'searchTitle': $('#searchTitle').val(),
            'searchDate': $('#date').val(),
            'listUrl': '/view/manageNotice.html'
        });
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
    /** end of components ***********************/


    /** start of grid ***********************/
    $("#grid").jsGrid({
        width: "100%",
        height: "381px",
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

            var $row = this.rowByItem(args.item),
            selectedRow = $("#grid").find('table tr.highlight');

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
                width: 15
            },
            { name: "templateNm", title: '템플릿명', type: "text", width: 200, editing: false, align: "left", cellRenderer: function(item, value) {
                var rslt = $("<td>").addClass("jsgrid-cell");
                var aLink = $("<a>");
                $(aLink).attr('href', '#');
                $(aLink).text(item);

                (function(value) {

                    $(aLink).on('click', function(e) {

                        e.preventDefault();
    
                        fnGo('/view/updateNotice.html', {
                            'searchTitle': $('#searchTitle').val(),
                            'searchDate': $('#date').val(),
                            'listUrl': '/view/manageNotice.html',
                            'rowKey': value['rowKey']
                        });
                    });

                }(value));

                $(rslt).append(aLink);
                
                return rslt;
            } }

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

            window.FakeLoader.hideOverlay();

        });
    }


    //상세 조회
    function fnRetrieveDetail(item) {

        $('#templateNm').val(item['templateNm']);
        $('#detailText').val(item['detailText']);
        /* var searchCompany = compCd;

        window.FakeLoader.showOverlay();

        parent.database.ref('/'+ searchCompany+'/categories/'+ item['rowKey'] + '/lecture').once('value').then(function(snapshot) {
    
            var catArr = snapshot.val();
            var rsltArr = [];

            $.each(catArr, function(idx) {
                var catObj = catArr[idx];
                catObj['rowKey'] = idx;
                rsltArr.push(catObj);
            });

            $("#detailGrid").jsGrid("option", "data", rsltArr);

            window.FakeLoader.hideOverlay();
        }); */
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


    //초기화
    function fnInit() {

        var searchParam = getParams();
        
        if(Object.keys(searchParam).length > 0) {
            $('#title').val(searchParam['searchTitle']);
            $('#date').val(searchParam['searchDate']).trigger('change');
        }

        fnRetrieve();

    }
    /** start of grid ***********************/




    resizeFrame();
    fnInit();

});