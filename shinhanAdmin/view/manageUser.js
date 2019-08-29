$(document).ready(function () {

    window.FakeLoader.init( );

    /** start of components ***********************/
    fnGetCommonCmb('company', '#searchCompany');
    /** end of components *************************/
    

     //검색 버튼
     $('#btnSearch').on('click', function(e) {
        e.preventDefault();
        $('#grid2').jsGrid("option", "data", []);
        fnRetrieve();
    });


      /** start of grid ***********************/
    $("#grid1").jsGrid({
        width: "100%",
        height: "300px",
        //inserting: true,
        //editing: false,
        sorting: true,
        paging: false,
        //filtering: true,
        data: [],
    
    
        rowClick: function(args) {
            //showDetailsDialog("Edit", args.item);
            var arr = $('#grid1').jsGrid('option', 'data');
            
            var memberObj = arr[args.itemIndex]['member'];
    
            fnRetrieveDetail(memberObj);
    
            var $row = this.rowByItem(args.item),
            selectedRow = $("#grid1").find('table tr.highlight');
            
            if (selectedRow.length) {
                selectedRow.toggleClass('highlight');
            };
            
            $row.toggleClass("highlight");
        },

        fields: [
            { name: "compNm", title: '회사명', type: "text", width: 120, editing: false, align: "center" },
            { name: "department", title: '부서명', type: "text", width: 120, editing: false, align: "center" },
            { name: "empNo", title: '사번', type: "text", width: 120, editing: false, align: "center" },
            { name: "name", title: "성명", type: 'text', width: 120, editing: false, align: "center" },
            { name: "selectedTags", title: "관심태그", type: 'text', width: 150, editing: false, align: "left", cellRenderer: function(item, value){
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
              } },
            { name: "listenClass", title: "수강강좌수", type: 'text', width: 100, editing: false, align: "center" }
        ]
        
    });
    //data: clients,
      /** start of grid ***********************/

      $("#grid2").jsGrid({
        width: "100%",
        height: "200px",
        sorting: true,
        paging: false,
        data: [],
    
        rowClick: function(args) {
            //showDetailsDialog("Edit", args.item);
            var arr = $('#grid2').jsGrid('option', 'data');
        },
        fields: [
            { name: "listenName", title: '수강과목명', type: "text", width: 120, editing: false, align: "center" },
            { name: "category", title: "강좌 카테고리", type: "text", width: 150, editing: false, align: "center" },
            { name: "listenDay", title: "수강날짜", type: 'text', width: 150, editing: false, align: "center" },
            { name: "teacherName", title: "강사명", type: 'text', width: 150, editing: false, align: "center" }
        ]
        
    });
 
    //조회
    function fnRetrieve() {
        window.FakeLoader.showOverlay();
        
        var searchCompany = $('#searchCompany').val() || '';//회사명
        var searchempNm = $('#empNm').val() || '';//사용자이름
        var searchempNo = $('#empNo').val() || '';//사번

        parent.database.ref('/user').once('value').then(function(snapshot)
        {

            var catArr = snapshot.val();
            var rsltArr = [];

            $.each(catArr, function(idx, studyObj) {

                if( 
                    ((searchempNm == '') || (studyObj['name'].indexOf(searchempNm) > -1)) &&
                    ((searchempNo == '') || (studyObj['empNo'] == searchempNo)) &&
                    ((searchCompany == '') ||(studyObj['compCd'] == searchCompany)) &&
                    (studyObj['roleCd'] != 'admin')
                ) {
                   // var mbrCnt = Object.keys(studyObj['member'] || []).length+1;
                    //studyObj['participant'] = mbrCnt;
                    rsltArr.push(studyObj);
                }
                
            });

            $("#grid1").jsGrid("option", "data", rsltArr);

            window.FakeLoader.hideOverlay();

            $('#grid1').find('tr.jsgrid-row:eq(0)').click(); //첫번째 row click
        });
    }


    function fnRetrieveDetail(memeberObj) {
    
        window.FakeLoader.showOverlay();
        
        var memArr = [];
    
        $("#grid2").jsGrid("option", "data", memArr);
    
        window.FakeLoader.hideOverlay();
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



    resizeFrame();
    fnRetrieve();

});