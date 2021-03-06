

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
        
        var memberObj = arr[args.itemIndex]['member'];

        fnRetrieveDetail(memberObj);
    },

    //data: clients,

    fields: [
        { name: "number", title: '스터디번호', type: "text", width: 100, editing: false, align: "center" },
        { name: "studyname", title: '스터디명', type: "text", width: 120, editing: false, align: "left" },
        { name: "tags", title: "관련태그", type: 'text', width: 200, editing: false, align: "left" },
        { name: "creator", title: "개설자", type: 'text', width: 150, editing: false, align: "left" },
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
    var memArr = [];

    $.each(memeberObj, function(idx, value) {
        memArr.push({empNo: idx, empName: value});
    });

    $("#grid2").jsGrid("option", "data", memArr);
}


   /** start of grid ***********************/
   $("#grid2").jsGrid({
    width: "100%",
    height: "200px",
    sorting: true,
    paging: false,
    data: [],
    fields: [
        { name: "empNo", title: "사번", type: 'text', width: 100, editing: false, align: "center" },
        { name: "empName", title: '성명', type: "text", width: 200, editing: false, align: "left" }
    ]
});

//조회
function fnRetrieve() {
    var searchStudy = $('#stduyname').val() || '';//스터디명
    var searchMember = $('#member').val() || '';//팀원명
    var searchCompany = $('#searchCompany').val() || '';

    searchCompany = searchCompany.toLowerCase();

    firebase.database().ref('/study/' + searchCompany).once('value').then(function(snapshot) {

        var catArr = snapshot.val();
        var rsltArr = [];

        $.each(catArr, function(company, studyObj) {

            if( 
                 ((searchStudy== '') || (studyObj['studyname'] == searchStudy)) &&
                 ((searchMember == '') || (Object.keys(studyObj['member']).indexOf(searchMember)) > -1)
             ) {
                 var mbrCnt = Object.keys(studyObj['member'] || []).length+1;
                 studyObj['participant'] = mbrCnt;
                 rsltArr.push(studyObj);
             }
            
        });

        $("#grid1").jsGrid("option", "data", rsltArr);
    });
}




    resizeFrame();

});