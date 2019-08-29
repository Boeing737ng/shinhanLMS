

$(document).ready(function () {

    var userInfo = JSON.parse(window.sessionStorage.getItem('userInfo'));
    var compCd = userInfo['compCd'];
    

    /** start of components ***********************/
    window.FakeLoader.init( );


    $('#searchCompany').selectpicker();


    //검색 버튼
    $('#btnSearch').on('click', function(e) {
        e.preventDefault();
        $('#grid2').jsGrid("option", "data", []);
        $('#grid3').jsGrid("option", "data", []);
        fnRetrieve();
    });
    /** end of components *************************/


   /** start of grid ***********************/
   $("#grid1").jsGrid({
    width: "100%",
    height: "300px",
    //inserting: true,
    //editing: true,
    sorting: true,
    paging: false,
    //filtering: true,
    data: [],

    rowClick: function(args) {
        //showDetailsDialog("Edit", args.item);
        var arr = $('#grid1').jsGrid('option', 'data');
        
        var memberObj = arr[args.itemIndex]['members'];
        fnRetrieve2(memberObj);

        var $row = this.rowByItem(args.item),
        selectedRow = $("#grid1").find('table tr.highlight');
        
        if (selectedRow.length) {
            selectedRow.toggleClass('highlight');
        };
        
        $row.toggleClass("highlight");
    },

    //data: clients,

    fields: [
       
        { name: "studyName", title: '스터디명', type: "text", width: 120, editing: false, align: "left" },
        /*{ name: "creator", title: "개설자", type: 'text', width: 150, editing: false, align: "left" },*/
        { name: "date", title: "등록일자", type: 'text', width: 150, editing: false, align: "center", cellRenderer: function(item, value){
            var rslt = $("<td>").addClass("my-row-custom-class");
            var date = moment(item, 'YYYYMMDDHHmmss').format('YYYY-MM-DD');
            $(rslt).append(date);
            return rslt; 
          } },
        
        { name: "participant", title: "참여자수", type: 'text', width: 100, editing: false, align: "center" }
    ]
});


function fnRetrieveDetail(memeberObj) {
    
    window.FakeLoader.showOverlay();
    
    var memArr = [];

    $.each(memeberObj, function(idx, value) {
        memArr.push({empNo: idx, empName: value});
    });

    $("#grid2").jsGrid("option", "data", memArr);
    $("#grid3").jsGrid("option", "data", memArr);

    window.FakeLoader.hideOverlay();
}


   /** start of grid ***********************/
   /**스터디 참여자 리스트 **/
   $("#grid2").jsGrid({
    width: "100%",
    height: "200px",
    sorting: true,
    paging: false,
    data: [],
    fields: [
        { name: "compNm", title: "회사명", type: 'text', width: 150, editing: false, align: "center" },
        { name: "empNo", title: "사번", type: 'text', width: 150, editing: false, align: "center" },
        { name: "empName", title: '성명', type: "text", width: 100, editing: false, align: "left" }
    ]
    });

   /** start of grid ***********************/
   /**스터디 커리큘럼 리스트 **/
   $("#grid3").jsGrid({
    width: "100%",
    height: "200px",
    sorting: true,
    paging: false,
    data: [],
    fields: [
        { name: "author", title: "강사명", type: 'text', width: 100, editing: false, align: "center" },
        { name: "title", title: '컨텐츠명', type: "text", width: 200, editing: false, align: "left" }
    ]
    });


//grid 1조회 
function fnRetrieve1() {
    window.FakeLoader.showOverlay();
    
    var searchStudy = $('#studyName').val() || '';//스터디명
    var searchMember = $('#creator').val() || '';//개설자
    var searchCompany = $('#date').val() || '';//등록일자

    parent.database.ref('/'+ '신한은행'+'/study').once('value').then(function(snapshot)
    {

        var catArr = snapshot.val();
        var rsltArr = [];

        $.each(catArr, function(idx, studyObj) {
            if( 
                 ((searchStudy== '') || (studyObj['studyname'].indexOf(searchStudy) > -1))

                 
             ) {
                 var mbrCnt = Object.keys(studyObj['members'] || []).length+1;
                 studyObj['participant'] = mbrCnt;

                 rsltArr.push(studyObj);
             }
            
        });
       
        $("#grid1").jsGrid("option", "data", rsltArr);

        window.FakeLoader.hideOverlay();

        $('#grid1').find('tr.jsgrid-row:eq(0)').click(); //첫번째 row click
    });
}


//grid 2조회 
function fnRetrieve2(memberObj) {
    window.FakeLoader.showOverlay();

    console.log(memberObj);
    

    /* parent.database.ref('/'+ '신한은행'+'/study'+'/members').once('value').then(function(snapshot)
    {

        var catArr = snapshot.val();

        console.log(catArr);

        var rsltArr = [];

        $.each(catArr, function(idx, studyObj) {

                 rsltArr.push(studyObj);
            
        });
       
        $("#grid2").jsGrid("option", "data", rsltArr);

        window.FakeLoader.hideOverlay();

        $('#grid2').find('tr.jsgrid-row:eq(0)').click(); //첫번째 row click
    }); */
}







    resizeFrame();
    fnRetrieve1();
    //fnRetrieve2();
    //fnRetrieve3();


});