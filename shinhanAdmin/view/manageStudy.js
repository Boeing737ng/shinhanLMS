

$(document).ready(function () {

    /** start of components ***********************/
    $('#searchOpenYn').selectpicker();
    $('#searchCategory').selectpicker();
    $('#searhRelatedTag').selectpicker();


    //행추가 버튼
    $('#btnAdd').on('click', function(e) {
        e.preventDefault();
        
        grid.appendRow({
            name: '',
            release: '',
            creator: '',
            date: '',
            participant: ''
        }, {focus: true});
    });


    //행삭제 버튼
    $('#btnDel').on('click', function(e) {
        e.preventDefault();

        if(grid.getCheckedRows().length == 0) {
            alert('선택된 데이터가 없습니다.');
            return false;
        }

        if(confirm("삭제하시겠습니까?")) {
            grid.removeCheckedRows();
        }
    });
    /** end of components *************************/


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
        { name: "name", title: '스터디명', type: "text", width: 120, editing: false, align: "center" },
        { name: "tags", title: "관련태그", type: 'text', width: 200, editing: false, align: "center" },
        { name: "creator", title: "개설자", type: 'text', width: 150, editing: false, align: "center" },
        { name: "date", title: "등록일자", type: 'text', width: 150, editing: false, align: "center" },
        { name: "participant", title: "참여자수", type: 'text', width: 100, editing: false, align: "center" }

        //{ type: "control" } //edit control
    ]
});



    /* var arr = [{
        name: 'Beautiful Lies',
        artist: 'Birdy',
        release: '2016.03.26',
        type: 'Deluxe',
        genre: 'Pop'
      }];
    grid.resetData(arr); */


    
    /** end of grid *************************/


    resizeFrame();

});