

$(document).ready(function () {

    /** start of components ***********************/
    $('#searchOpenYn').selectpicker();
    $('#searchCategory').selectpicker();
    $('#searhRelatedTag').selectpicker();
    $('#searchCompany').selectpicker();
    $('#searchRegDate').datepicker();
    $('#date').datepicker();

    $.datepicker.setDefaults({
        dateFormat: 'yy-mm-dd' //Input Display Format 변경
    });
      
      

    //행추가 버튼 -> 페이지 이동
    $('#btnAdd').on('click', function(e) {
        e.preventDefault();
        window.location.href = "/view/registerNotice.html";
        //location.replace("http://localhost/view/addNotice.html");

    });

    $('#btnDel').on('click', function(e) {
        e.preventDefault();

        if(selectedItems.length == 0) {
            alert('선택된 데이터가 없습니다.');
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
    $('#btnSearch').on('click', function(e) {
        e.preventDefault();
        $('#grid1').jsGrid("option", "data", []);
        fnRetrieve();
    });


    
   /** start of grid ***********************/
   $("#grid").jsGrid({
    width: "100%",
    height: "300px",
    sorting: true,
    paging: false,
    data: [],

    rowClick: function(args) {
        //showDetailsDialog("Edit", args.item);
        var arr = $('#grid').jsGrid('option', 'data');
        
        var memberObj = arr[args.itemIndex]['member'];

        fnRetrieveDetail(memberObj);

        var $row = this.rowByItem(args.item),
        selectedRow = $("#grid").find('table tr.highlight');
        
        if (selectedRow.length) {
            selectedRow.toggleClass('highlight');
        };
        
        $row.toggleClass("highlight");
    },

    //data: clients,

    fields: [
        /*{
            itemTemplate: function(_, item) {
                return $("<input>").attr("type", "checkbox")
                        .addClass('selectionCheckbox')
                        .prop("checked", $.inArray(item, selectedItems) > -1)
                        .on("change", function () {
                            $(this).is(":checked") ? selectItem(item) : unselectItem(item);
                        });
            },
            align: "center",
            width: 30
        },*/
        { name: "title", title: '제목', type: "text", width: 120, editing: false, align: "left" },
        { name: "writor", title: "작성자", type: 'text', width: 200, editing: false, align: "left" },
        { name: "date", title: "등록일자", type: 'text', width: 150, editing: false, align: "center", cellRenderer: function(item, value){
            var rslt = $("<td>").addClass("my-row-custom-class");
            var date = moment(item, 'YYYYMMDDHHmmss').format('YYYY-MM-DD');
            $(rslt).append(date);
            return rslt; 
          } },
        { name: "creator", title: "공개여부", type: 'text', width: 150, editing: false, align: "left" },
        
    ]
});

//조회
function fnRetrieve(callback) {
    var searchTitle = $('#title').val() || '';
    var searchWritor = $('#writor').val() || '';
    var searchDate = $('#date').val() || '';

    //searchCompany = searchCompany.toLowerCase();

    console.log(searchTitle)
   

    firebase.database().ref('/'+ '신한은행'+'/notie').once('value').then(function(snapshot)
    {   //log.console(searchㅅTitle)

        var catArr = snapshot.val();
        var rsltArr = [];

        $.each(catArr, function(idx, studyObj) {

            if( 
                 ((searchTitle== '') || (studyObj['writor'].indexOf(search) > -1))
             ) {
                 var mbrCnt = Object.keys(studyObj['member'] || []).length+1;
                 studyObj['participant'] = mbrCnt;
                 rsltArr.push(studyObj);
             }
            
        });

        $("#grid").jsGrid("option", "data", rsltArr);

    });
}




    resizeFrame();
    //fnRetrieve();

});