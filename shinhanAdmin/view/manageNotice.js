

$(document).ready(function () {

    /** start of components ***********************/
    $('#searchOpenYn').selectpicker();
    $('#searchCategory').selectpicker();
    $('#searhRelatedTag').selectpicker();

    $('#searchRegDate').datepicker();


    //행추가 버튼 -> 페이지 이동
    $('#btnAdd').on('click', function(e) {
        e.preventDefault();
        
        window.location.href = "/view/registerNotice.html";
        //location.replace("http://localhost/view/addNotice.html");

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
    var grid = new tui.Grid({
        el: document.getElementById('grid'),
        rowHeaders: ['checkbox', 'rowNum'],
        data: [],
        bodyHeight: 500,
        scrollX: false,
        scrollY: true,
        columns: [
            {
                header: '제목',
                name: 'name',
                minWidth: 100
            },
            {
                header: '작성자',
                name: 'creator',
                minWidth: 120
            },
            {
                header: '등록일자',
                name: 'date',
                minWidth: 120
            },
            {
                header: '공개여부',
                name: 'showYN',
                minWidth: 120
            },
            {
                header: '삭제',
                name: 'delete',
                minWidth: 70
            }
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


    var ref = firebase.database().ref();                           
    ref.on("value", function(snapshot){
        output.innerHTML = JSON.stringify(snapshot.val(), null, 2);
    });

    //resize frame height
    resizeFrame();

});