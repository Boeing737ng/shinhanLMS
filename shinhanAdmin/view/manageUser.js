$(document).ready(function () {

    /** start of components ***********************/
    $('#searchCompany').selectpicker();
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
        height: "500px",
        //inserting: true,
        //editing: false,
        sorting: true,
        paging: false,
        //filtering: true,
        data: [],
    
        //data: clients,
    
        rowClick: function(args) {
            //showDetailsDialog("Edit", args.item);
            var arr = $('#grid').jsGrid('option', 'data');
        },
        fields: [
            { name: "empNo", title: '사번', type: "text", width: 120, editing: false, align: "center" },
            { name: "empNm", title: "성명", type: 'text', width: 150, editing: false, align: "center" },
            { name: "interestedTag", title: "관심태그", type: 'text', width: 150, editing: false, align: "center" },
            { name: "mail", title: "이메일", type: 'text', width: 150, editing: false, align: "center" },
            { name: "listenClass", title: "수강강좌수", type: 'text', width: 150, editing: false, align: "center" }
        ]
        
    });
    //data: clients,
      /** start of grid ***********************/

      $("#grid2").jsGrid({
        width: "100%",
        height: "300px",
        sorting: true,
        paging: false,
        //filtering: true,
        data: [],
    
        //data: clients,
    
        rowClick: function(args) {
            //showDetailsDialog("Edit", args.item);
            var arr = $('#grid').jsGrid('option', 'data');
        },
        fields: [
            { name: "listenName", title: '수강과목명', type: "text", width: 120, editing: false, align: "center" },
            { name: "category", title: "카테고리", type: "text", width: 150, editing: false, align: "center" },
            { name: "relatedTag", title: "관련태그", type: 'text', width: 150, editing: false, align: "center" },
            { name: "teacherName", title: "강사명", type: 'text', width: 150, editing: false, align: "center" }
        ]
        
    });
 
    //조회
function fnRetrieve(callback) {
    var searchCompany = $('#searchCompany').val() || '';//회사명
    var searchempNm = $('#empNm').val() || '';//사용자이름
    var searchempNo= $('#empNo').val() || '';//사번
    
    searchCompany = searchCompany.toLowerCase();

    

    firebase.database().ref('/'+ searchCompany+'/user').once('value').then(function(snapshot)
    {

        var catArr = snapshot.val();
        var rsltArr = [];
        console.log(searchempNo)
        $.each(catArr, function(idx, studyObj) {

            if( 
                 ((searchempNm== '') || (studyObj['empNm'].indexOf(searchempNm) > -1))
            ) {
                 /*var mbrCnt = Object.keys(studyObj['member'] || []).length+1;
                 studyObj['participant'] = mbrCnt;
                 rsltArr.push(studyObj);*/
                 
             }
            
        });

        $("#grid1").jsGrid("option", "data", rsltArr);

    });
}



    resizeFrame();
    fnRetrieve();

});