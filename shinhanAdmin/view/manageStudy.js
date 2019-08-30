

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
        fnRetrieve1();
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
        

        var studyNo = args.item['rowKey'];
        //console.log(studyNo);

        fnRetrieve2(studyNo);
        fnRetrieve3(studyNo);

        var $row = this.rowByItem(args.item),
        selectedRow = $("#grid1").find('table tr.highlight');
        
        if (selectedRow.length) {
            selectedRow.toggleClass('highlight');
        };
        
        $row.toggleClass("highlight");
    },
    //data: clients,

    fields: [
       
        { name: "studyname", title: '스터디명', type: "text", width: 120, editing: false, align: "left" },
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
        { name: "department", title: "부서", type: 'text', width: 150, editing: false, align: "center" },
        { name: "name", title: '성명', type: "text", width: 100, editing: false, align: "left" }
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


//grid 1, 스터디리스트조회 
function fnRetrieve1() {
    window.FakeLoader.showOverlay();
    
    var searchStudy = $('#studyname').val() || '';//스터디
    var searchName =  $('#name').val() || '' //스터디원 이름
    var searchCompany = $('#date').val() || '';//등록일자

    parent.database.ref('/'+ '58'+'/study').once('value').then(function(snapshot)
    {

        var catArr = snapshot.val();
        var rsltArr = [];

        $.each(catArr, function(idx, studyObj) {
            if( 
                 ((searchStudy== '') || (studyObj['studyname'].indexOf(searchStudy) > -1))&&
                 ((searchName== '') || (studyObj['name']==searchMember))
             ) 
             
             {
                 studyObj['rowKey'] = idx;
                 //console.log(idx);
                 var mbrCnt = Object.keys(studyObj['member'] || []).length;
                 studyObj['participant'] = mbrCnt;
                 rsltArr.push(studyObj);
             }
            
        });
       
        $("#grid1").jsGrid("option", "data", rsltArr);

        window.FakeLoader.hideOverlay();

        $('#grid1').find('tr.jsgrid-row:eq(0)').click(); //첫번째 row click
    });
}


//grid 2, 스터디 참여자 리스트 조회 
function fnRetrieve2(studyNo) {

   
    window.FakeLoader.showOverlay();
    
    parent.database.ref('/'+ '58'+'/study/'+studyNo+'/member').once('value').then(function(snapshot)
    { 
       // console.log(studyNo);
        var catArr = snapshot.val();
        var rsltArr = [];
        $.each(catArr, function(idx, studyObj) {

            { 
                studyObj['rowKey'] = idx;
                rsltArr.push(studyObj);   
            }
            console.log(rsltArr);

        });
        $("#grid2").jsGrid("option", "data", rsltArr);

        window.FakeLoader.hideOverlay();

        $('#grid2').find('tr.jsgrid-row:eq(0)').click(); //첫번째 row click
    });
}


//grid 3, 커리큘럼조회 
function fnRetrieve3(studyNo) {
    window.FakeLoader.showOverlay();


    var searchstate = $('#state').val() || '';//사번

    parent.database.ref('/'+ '58'+'/study/'+ studyNo+'/curriculum').once('value').then(function(snapshot)
    {
        var catArr = snapshot.val();
        var rsltArr = [];
        $.each(catArr, function(idx, studyObj) {

            {  
                studyObj['rowKey'] = idx;

                rsltArr.push(studyObj);
                
            }
        
            
        });
        $("#grid3").jsGrid("option", "data", rsltArr);

        window.FakeLoader.hideOverlay();

        $('#grid3').find('tr.jsgrid-row:eq(0)').click(); //첫번째 row click
    });
}






    resizeFrame();
    fnRetrieve1();
    //fnRetrieve2();
    //fnRetrieve3();


});