

$(document).ready(function () {

    /** start of components ***********************/
    $('#searchCompany').selectpicker();
    /** end of components *************************/
    
    //검색 버튼
     $('#btnSearch').on('click', function(e) {
        e.preventDefault();
        fnRetrieve();
    });


   /** start of grid ***********************/
   $("#grid").jsGrid({
    width: "100%",
    height: "500px",
    //inserting: true,
    //editing: true,
    sorting: true,
    paging: false,
    //filtering: true,
    data: [],

    insertcss: 'editRow',

    //data: clients,

    

    fields: [
        //{ name: "Name", type: "text", width: 150, validate: "required" },
    
        { name: "number", title: '스터디번호', type: "text", width: 100, editing: false, align: "center" },
        { name: "studyname", title: '스터디명', type: "text", width: 120, editing: false, align: "center" },
        { name: "tags", title: "관련태그", type: 'text', width: 200, editing: false, align: "center" },
        { name: "creator", title: "개설자", type: 'text', width: 150, editing: false, align: "center" },
        { name: "date", title: "등록일자", type: 'text', width: 150, editing: false, align: "center", cellRenderer: function(item, value){
            var rslt = $("<td>").addClass("my-row-custom-class");
            var date = moment(item, 'YYYYMMDDHHmmss').format('YYYY-MM-DD');
            $(rslt).append(date);
            return rslt; 
          } },
        { name: "participant", title: "참여자수", type: 'text', width: 100, editing: false, align: "center" }

        //{ type: "control" } //edit control
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

            console.log(catArr);
            
            $.each(studyObj, function(idx, value) {
                //console.log(obj);
                
                if( 
                    //((searchCompany == '') || (searchCompany == studyObj['searchCompany'])) &&
     
                     //((searchCat == '') || (searchCat == catObj['category'])) &&
                     //((searchTag == '') || (trgtTagArr.indexOf(searchTag) > -1)) &&
     
                     ((searchStudy== '') || (studyObj['studyname'] == searchStudy)) &&
                     ((searchMember == '') || (Object.keys(studyObj['member']).indexOf(searchMember)) > -1)
     
                 ) {
                     var mbrCnt = Object.keys(studyObj['member']).length+1;
                     studyObj['participant'] = mbrCnt;
                     rsltArr.push(studyObj);
                 }
                
            });
            
        });

        console.log(rsltArr);

        $("#grid").jsGrid("option", "data", rsltArr);
        //$("#grid").jsGrid("refresh");
    });
}

    resizeFrame();

});