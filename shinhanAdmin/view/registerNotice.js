

$(document).ready(function () {

    /** start of components ***********************/
    $('#releaseYn').selectpicker();
    $('#regDate').text(moment().format('YYYY-MM-DD'));
    $('#template').selectpicker();
    fnGetCommonCmb('template', '#template');

    $('[data-toggle="tooltip"]').tooltip();


    $('#template').on('change', function(e) {
        var detailText = $(this).find('option:selected').attr('data-detail');
        $('#description').val(detailText);
    });



    var userInfo = JSON.parse(window.sessionStorage.getItem('userInfo'));
    var compCd = userInfo['compCd'];

    $('#writor').text(userInfo['name']);


    $('#btnGuide').on('click', function(e) {

        //modal-guide
        $('#modal-guide').modal();
    });


    $('#btnAddEmp').on('click', function(e) {
        e.preventDefault();

        if(!$(this).hasClass('active') && !confirm('기존에 선택한 수신자 목록가 초기화됩니다. 계속하시겠습니까?')) {
            return false;
        }

        $('#nonWatchEmpGrid').jsGrid('option', 'data', []);
        $('#nonWatchEmpGrid').hide();
        $('#trgtEmpGrid').show();

        var popup = SearchEmpListPopup.getInstance({
            title: '사원 검색'
        });

        $(popup).off('submit').on('submit', function(e, param) {
            var srcRecords = $('#trgtEmpGrid').jsGrid('option', 'data');
            var records = param['records'];
            var mergeRecords = [].concat(srcRecords);

            for(var i=0; i<records.length; i++) {
                var trgtRecord = records[i];
                var flag = true;

                for(var j=0; j<srcRecords.length; j++) {
                    var srcRecord = srcRecords[j];

                    if(trgtRecord['empNo'] == srcRecord['empNo']) {
                        flag = false;
                        break;
                    }
                }

                if(flag) {
                    mergeRecords.push(trgtRecord);
                }
            }
            
            $('#trgtEmpGrid').jsGrid('option', 'data', mergeRecords);
        });

        popup.open();
        
    });


    //필수강좌 미이수자 팝업 버튼
    $('#btnLoadEmpNonWatch').on('click', function(e) {
        e.preventDefault();

        if(!$(this).hasClass('active') && !confirm('기존에 선택한 수신자 목록가 초기화됩니다. 계속하시겠습니까?')) {
            return false;
        }

        $('#trgtEmpGrid').jsGrid('option', 'data', []);
        $('#trgtEmpGrid').hide();
        $('#nonWatchEmpGrid').show();

        var popup = searchEmpListNonWatchPopup.getInstance({
            title: '필수강좌 미이수자 검색'
        });

        $(popup).off('submit').on('submit', function(e, param) {
            var srcRecords = $('#nonWatchEmpGrid').jsGrid('option', 'data');
            var records = param['records'];
            var mergeRecords = [].concat(srcRecords);

            for(var i=0; i<records.length; i++) {
                var trgtRecord = records[i];
                var flag = true;

                for(var j=0; j<srcRecords.length; j++) {
                    var srcRecord = srcRecords[j];

                    if(trgtRecord['empNo'] == srcRecord['empNo'] && trgtRecord['videoId'] == srcRecord['videoId']) {
                        flag = false;
                        break;
                    }
                }

                if(flag) {
                    mergeRecords.push(trgtRecord);
                }
            }

            $('#nonWatchEmpGrid').jsGrid('option', 'data', mergeRecords);
        });

        popup.open();
    });


    //목록 버튼
    $('#btnList').on('click', function(e) {
        e.preventDefault();
        fnGoList();
    });
    

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


    //수신자 목록 삭제
    $('#btnDelEmpList').on('click', function(e) {

        e.preventDefault();

        if($('#btnAddEmp').hasClass('active')) {
            removeCheckedRows('trgt');
        }else {
            removeCheckedRows('nonWatch');
        }

    });
    /** end of components *************************/


    /** start of grid ***********************/
    //특정 사원 그리드
    $("#trgtEmpGrid").jsGrid({
        width: "100%",
        height: "200px",
        sorting: true,
        paging: false,
        data: [],
        confirmDeleting: false,
        fields: [
            {
                itemTemplate: function(_, item) {
                    return $("<input>").attr("type", "checkbox")
                            .addClass('selectionCheckbox')
                            .prop("checked", $.inArray(item, trgtEmpSelectedItems) > -1)
                            .on("change", function () {
                                if($(this).is(":checked")) {
                                    selectItem('trgt', item);
                                }else {
                                    unselectItem('trgt', item);
                                    $("#trgtEmpGrid").find('.selectionHeaderCheckbox').prop('checked', false);
                                }
                            });
                },
                headerTemplate: function(_, item) {
                    return $("<input>").attr("type", "checkbox")
                            .addClass('selectionHeaderCheckbox')
                            .on("change", function () {
                                if($(this).is(":checked")) {
                                    $("#trgtEmpGrid").find('.selectionCheckbox:not(input[type=checkbox]:checked)').each(function() {
                                        $(this).click();
                                    });
                                }else {
                                    $("#trgtEmpGrid").find('.selectionCheckbox:checked').each(function() {
                                        $(this).click();
                                    });
                                }
                            });
                },
                align: "center",
                sorting: false,
                width: 20
            },
            { name: "empNo", title: '사번', type: "text", width: 100, editing: false, align: "center" },
            { name: "name", title: '성명', type: "text", width: 100, editing: false, align: "center" },
            { name: "compNm", title: "회사명", type: 'text', width: 150, editing: false, align: "left" },
            { name: "department", title: '부서명', type: "text", width: 200, editing: false, align: "left" }
        ]
    });


    //필수강좌 미이수자 그리드
    $("#nonWatchEmpGrid").jsGrid({
        width: "100%",
        height: "200px",
        sorting: true,
        paging: false,
        data: [],
        confirmDeleting: false,
        fields: [
            {
                itemTemplate: function(_, item) {
                    return $("<input>").attr("type", "checkbox")
                            .addClass('selectionCheckbox')
                            .prop("checked", $.inArray(item, nonWatchEmpSelectedItems) > -1)
                            .on("change", function () {
                                if($(this).is(":checked")) {
                                    selectItem('nonWatch', item);
                                }else {
                                    unselectItem('nonWatch', item);
                                    $("#nonWatchEmpGrid").find('.selectionHeaderCheckbox').prop('checked', false);
                                }
                            });
                },
                headerTemplate: function(_, item) {
                    return $("<input>").attr("type", "checkbox")
                            .addClass('selectionHeaderCheckbox')
                            .on("change", function () {
                                if($(this).is(":checked")) {
                                    $("#nonWatchEmpGrid").find('.selectionCheckbox:not(input[type=checkbox]:checked)').each(function() {
                                        $(this).click();
                                    });
                                }else {
                                    $("#nonWatchEmpGrid").find('.selectionCheckbox:checked').each(function() {
                                        $(this).click();
                                    });
                                }
                            });
                },
                align: "center",
                sorting: false,
                width: 20
            },
            { name: "empNo", title: '사번', type: "text", width: 100, editing: false, align: "center" },
            { name: "name", title: '성명', type: "text", width: 100, editing: false, align: "center" },
            { name: "compNm", title: "회사명", type: 'text', width: 100, editing: false, align: "left" },
            { name: "department", title: '부서명', type: "text", width: 120, editing: false, align: "left" },
            { name: "title", title: '미이수강의명', type: "text", width: 200, editing: false, align: "left" }
        ]
    });
    /** end of grid *************************/


    var trgtEmpSelectedItems = [];
    var nonWatchEmpSelectedItems = [];


    //체크된 건들 삭제
    function removeCheckedRows(option) {

        var selectedItems = (option == 'trgt') ? trgtEmpSelectedItems : nonWatchEmpSelectedItems;
        var grid = (option == 'trgt') ? $('#trgtEmpGrid') : $('#nonWatchEmpGrid');

        for(var i=0; i<selectedItems.length; i++) {
            var item = selectedItems[i];
            grid.jsGrid("deleteItem", item);
        }

        selectedItems = [];
    }


    function selectItem(option, item) {
        if(option == 'trgt') {
            trgtEmpSelectedItems.push(item);
        }else {
            nonWatchEmpSelectedItems.push(item);
        }
        
    }


    function unselectItem(option, item) {
        if(option == 'trgt') {
            trgtEmpSelectedItems = $.grep(trgtEmpSelectedItems, function(i) {
                return i !== item;
            });
        }else {
            nonWatchEmpSelectedItems = $.grep(nonWatchEmpSelectedItems, function(i) {
                return i !== item;
            });
        }
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
        var paramObj = getParams();
        var url = paramObj['listUrl'];

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

        console.log(paramObj);

        $('body').append(form);
        $(form).submit();
    }


    //validataion
    function fnValidate() {
        var errMsg = '';
        var param = '';
        var target;

        var empGridRowCnt = ($('#btnAddEmp').hasClass('active')) ? $('#trgtEmpGrid').jsGrid('option', 'data').length : $('#nonWatchEmpGrid').jsGrid('option', 'data').length;

        if(empGridRowCnt == 0) {
            param = '수신자 목록';
            target = $('#btnAddEmp');
        }
        else if(isEmpty($('#title').val())) {
            param = ' 제목';
            target = $('#title');
        }
        else if(isEmpty($('#description').val())) {
            param = '내용';
            target = $('#description');
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

        var writor = $('#writor').text();
        var title=$('#title').val();
        var description = $('#description').val();

        var userRecords = ($('#btnAddEmp').hasClass('active')) ? $('#trgtEmpGrid').jsGrid('option', 'data') : $('#nonWatchEmpGrid').jsGrid('option', 'data');
        console.log(userRecords);
        var targetUsers = {};

        var timestamp = Date.now();

        for(var i=0; i<userRecords.length; i++) {
            var user = userRecords[i];
            var empNo = user.empNo;
            var empNm = user.name;
            var compNm = user.compNm;
            var deptNm = user.department;
            var content = user.title || '';

            var newObj = {
                'empNo': empNo,
                'name': empNm,
                'compNm': compNm,
                'department': deptNm,
                'content': content,
                'noticeId': moment().unix()
            };

            targetUsers[empNo + '_' + (timestamp++)] = newObj;
        }

        console.log(targetUsers);

        setNotieDatabase({
            writor: writor,
            description: description,
            date: moment().format('YYYYMMDDHHmm'),
            title: title,
            targetUsers: targetUsers
        }, callback);
    }


    function setNotieDatabase(paramObj, callback) {

        //var row
        var rowKey = 'notie_' + moment().unix(); 

        parent.database.ref('/'+ compCd +'/notie/' + rowKey).set(paramObj).then(function onSuccess(res) {
            if(callback != null && callback != undefined) {
                callback();
            }
        }).catch(function onError(err) {
            console.log("ERROR!!!! " + err);
        });
    }


    //combo 구성
    function fnGetCommonCmb(option, selector) {

        $('' + selector + ' > option').remove();
        

        switch (option) {
            case 'template':
                $('' + selector + ' > option').remove();
                $('' + selector).append($('<option value="">선택</option>'));

                parent.database.ref('/notieTemplate/').once('value')
                    .then(function (snapshot) {
                        var arr = snapshot.val();

                        $.each(arr, function (idx, val) {
                            var newOption = $('<option></option>');
                            $(newOption).attr('value', idx);
                            $(newOption).text(val['templateNm']);
                            $(newOption).attr('data-detail', val['detailText']);

                            $('' + selector).append($(newOption));
                        });

                        $('' + selector).selectpicker('refresh');
                    });
                break;
        }
    }


    //ifame height resize
    resizeFrame();

});