
var searchEmpListNonWatchPopup = (function() {

    var instance;
    var grid;
    var selectedItems = [];
 

    function selectItem(item) {
        selectedItems.push(item);
    }


    function unselectItem(item) {
        selectedItems = $.grep(selectedItems, function(i) {
            return i !== item;
        });
    }


    //팝업 초기화
    function fnClear() {
        selectedItems = [];
        grid.jsGrid('option', 'data', []);
        $("#modal-searchEmpListNonWatch .grid").find('.selectionHeaderCheckbox').prop('checked', false);
        //var firstVal = $("#modal-searchEmpListNonWatch").find('select.searchCompany > option:eq(0)').val();
        //$("#modal-searchEmpListNonWatch .grid").find('select.searchCompany').val(firstVal);
    }


    //validate
    function fnValidate(option) {

        var rslt = true;

        switch(option) {
            //조회
            case 'SEARCH':
                if(isEmpty($('#modal-searchEmpListNonWatch select.searchCompany').val())) {
                    alert('회사명 은 필수입력 입니다.');
                    rslt = false;
                }
                break;

            //확인
            case 'SUBMIT':
                if(selectedItems.length == 0) {
                    alert('선택된 데이터가 없습니다.');
                    rslt = false;
                }
                break;
        }

        return rslt;
    }


    //조회
    function fnRetrieve() {

        var searchCompany = $('#modal-searchEmpListNonWatch select.searchCompany').val() || '';
        var searchDept = $('#modal-searchEmpListNonWatch select.searchDept').val() || '';
        var searchEmpNm = $('#modal-searchEmpListNonWatch .searchNm').val() || '';

        parent.database.ref('/user/').once('value').then(function (snapshot) {
            
            var arr = snapshot.val();
            var rsltArr = [];

            $.each(arr, function (empNo, empObj) {

                if(
                    (isEmpty(searchCompany) || searchCompany == empObj['compCd']) &&
                    (isEmpty(searchDept) || searchDept == empObj['deptCd']) &&
                    (isEmpty(searchEmpNm) || searchEmpNm == empObj['name']) &&
                    (empObj['roleCd'] != 'admin')
                ) {
                    empObj['empNo'] = empNo;
                    rsltArr.push(empObj);
                }
            });

            grid.jsGrid('option', 'data', rsltArr);
        });
    }


    function fnSubmit() {
        var e = jQuery.Event( "submit" );
        $(instance).trigger('submit', {'records' : selectedItems});
    }


    //body에 팝업 html 그려주기
    function fnDrawPopupHtml() {

        var popupHtml = '';

        $.ajax({
            url: '/view/popup/searchEmpListNonWatchPopup.html',
            async: false,
            success: function(html) {
                popupHtml = html;
            }
        })

        $('body').append(popupHtml);
    }


    //combo 구성
    function fnGetCommonCmb(option, selector, parentCd) {

        $('' + selector + ' > option').remove();
        

        switch (option) {
            case 'company':
                parent.database.ref('/company/').once('value')
                    .then(function (snapshot) {
                        var arr = snapshot.val();

                        $.each(arr, function (idx, val) {
                            var newOption = $('<option></option>');
                            $(newOption).attr('value', idx);
                            $(newOption).text(val);

                            $('' + selector).append($(newOption));
                        });

                        $('' + selector).selectpicker();
                        $('' + selector).trigger('change');
                    });
                break;

            case 'department':
                $('' + selector + ' > option').remove();
                $('' + selector).append($('<option value="">전체</option>'));

                parent.database.ref('/department/' + parentCd).once('value')
                    .then(function (snapshot) {
                        var arr = snapshot.val();

                        $.each(arr, function (idx, val) {
                            var newOption = $('<option></option>');
                            $(newOption).attr('value', idx);
                            $(newOption).text(val['deptNm']);

                            $('' + selector).append($(newOption));
                        });

                        $('' + selector).selectpicker('refresh');
                    });
                break;


            case 'category':
                //searchRequiredCat 
                break;

            case 'content':
                //searchRequiredContent
                break;
        }
    }


    function init() {

        //body에 html 추가
        fnDrawPopupHtml();


        /** start of component ***********************/
        fnGetCommonCmb('company', '#modal-searchEmpListNonWatch select.searchCompany');
        $('#modal-searchEmpListNonWatch .searchDept').selectpicker();


        $('#modal-searchEmpListNonWatch .searchCompany').on('change', function(e) {
            var parentCd = $(this).val();
            fnGetCommonCmb('department', '#modal-searchEmpListNonWatch select.searchDept', parentCd);
        });


        $('#modal-searchEmpListNonWatch .btnSearch').on('click', function(e) {
            e.preventDefault();

            if(!fnValidate('SEARCH')) {
                return false;
            }

            fnRetrieve();
        });


        $('#modal-searchEmpListNonWatch .btnSubmit').on('click', function(e) {
            e.preventDefault();

            if(!fnValidate('SUBMIT')) {
                return false;
            }

            fnSubmit();
            $("#modal-searchEmpListNonWatch").modal('hide');
        });
        /** end of component ***********************/
        

        /** start of grid ***********************/
        grid = $("#modal-searchEmpListNonWatch .grid").jsGrid({
            width: "100%",
            height: "200px",
            sorting: true,
            paging: false,
            data: [],
            fields: [
                {
                    itemTemplate: function(_, item) {
                        return $("<input>").attr("type", "checkbox")
                                .addClass('selectionCheckbox')
                                .prop("checked", $.inArray(item, selectedItems) > -1)
                                .on("change", function () {
                                    if($(this).is(":checked")) {
                                        selectItem(item);
                                    }else {
                                        unselectItem(item);
                                        $("#modal-searchEmpListNonWatch .grid").find('.selectionHeaderCheckbox').prop('checked', false);
                                    }
                                });
                    },
                    headerTemplate: function(_, item) {
                        return $("<input>").attr("type", "checkbox")
                                .addClass('selectionHeaderCheckbox')
                                .on("change", function () {
                                    if($(this).is(":checked")) {
                                        $("#modal-searchEmpListNonWatch .grid").find('.selectionCheckbox:not(input[type=checkbox]:checked)').each(function() {
                                            $(this).click();
                                        });
                                    }else {
                                        $("#modal-searchEmpListNonWatch .grid").find('.selectionCheckbox:checked').each(function() {
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
        /** end of grid *************************/
        

        return {
            //팝업 open
            open: function() {
                $('#modal-searchEmpListNonWatch').modal();
            }
        }
    }
    


    return {
        getInstance: function(paramObj) {
            if(!instance) {
                instance = init();
            }

            fnClear();
            $('#modal-searchEmpListNonWatch .modal-title').text(paramObj['title'] || '');

            return instance;
        }
    }

})();