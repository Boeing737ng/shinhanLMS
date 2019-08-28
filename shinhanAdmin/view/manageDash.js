$(document).ready(function() {

    window.FakeLoader.init( );
    
/** start of grid ***********************/
/*스터디관리*/ 

$("#grid1").jsGrid({
    width: "100%",
    height: "248px",
    //inserting: true,
    //editing: true,
    sorting: true,
    paging: false,
    //filtering: true,
    data: [],
    //data: clients,
    fields: [
        { name: "studyname", title: '스터디명', type: "text", width: 120, editing: false, align: "center" },
        { name: "creator", title: "개설자", type: 'text', width: 150, editing: false, align: "center" },
        { name: "date", title: "등록일자", type: 'text', width: 150, editing: false, align: "center", cellRenderer: function(item, value){
            var rslt = $("<td>").addClass("my-row-custom-class");
            var date = moment(item, 'YYYYMMDDHHmmss').format('YYYY-MM-DD');
            $(rslt).append(date);
            return rslt; 
          } }
      
    ],


    
});

fnRetrieve1();


/*조회->스터디*/
function fnRetrieve1() {
    window.FakeLoader.showOverlay();
    
    var searchStudy = $('#studyname').val() || '';//스터디명
    var searchCreator = $('#creator').val() || '';//개설자
    var searchDate = $('#date').val() || '';//등록일자

    //searchCompany = searchCompany.toLowerCase();

    parent.database.ref('/'+ '신한은행'+'/study').once('value').then(function(snapshot)
    {

        var catArr = snapshot.val();
        var rsltArr = [];
        
        $.each(catArr, function(idx, studyObj) {
                 rsltArr.push(studyObj);
        });

        $("#grid1").jsGrid("option", "data", rsltArr);

        window.FakeLoader.hideOverlay();

        $('#grid1').find('tr.jsgrid-row:eq(0)').click(); //첫번째 row click
    });
}

/*공지사항관리*/
$("#grid2").jsGrid({
    width: "100%",
    height: "248px",
    //inserting: true,
    //editing: true,
    sorting: true,
    paging: false,
    //filtering: true,
    data: [],

    insertcss: 'editRow',

    //data: clients,


    fields: [
        { name: "title", title: '제목', type: "text", width: 120, editing: false, align: "center" },
        { name: "writor", title: "작성자", type: 'text', width: 150, editing: false, align: "center" },
        { name: "date", title: "등록일자", type: 'text', width: 150, editing: false, align: "center", cellRenderer: function(item, value){
            var rslt = $("<td>").addClass("my-row-custom-class");
            var date = moment(item, 'YYYYMMDDHHmmss').format('YYYY-MM-DD');
            $(rslt).append(date);
            return rslt; 
          } }
        

    ]
    
});

fnRetrieve2();

/*조회->공지사항*/
function fnRetrieve2() {
    window.FakeLoader.showOverlay();
    
    var searchStudy = $('#title').val() || '';//제목
    var searchCreator = $('#writor').val() || '';//작성자
    var searchDate = $('#date').val() || '';//등록일자

    parent.database.ref('/'+ '신한은행'+'/notie').once('value').then(function(snapshot)
    {

        var catArr = snapshot.val();
        var rsltArr = [];
        
        $.each(catArr, function(idx, studyObj) {
                 rsltArr.push(studyObj);
        });

        $("#grid2").jsGrid("option", "data", rsltArr);

        window.FakeLoader.hideOverlay();

        $('#grid2').find('tr.jsgrid-row:eq(0)').click(); //첫번째 row click
    });
}





    //resize frame height
    resizeFrame();
    
});
