

$('#contentDiv').off('load').on('load', function () {

    /** start of components ***********************/
    $('#searchOpenYn').selectpicker();
    $('#searchCategory').selectpicker();
    $('#searhRelatedTag').selectpicker();


    //행추가 버튼
    $('#btnAdd').on('click', function(e) {
        e.preventDefault();
        
        grid.appendRow({
            name: '',
            artist: '',
            release: '',
            type: '',
            genre: ''
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
    var grid = new tui.Grid({
        el: document.getElementById('grid'),
        rowHeaders: ['checkbox', 'rowNum'],
        data: [],
        bodyHeight: 500,
        scrollX: false,
        scrollY: true,
        columns: [
            {
                header: '컨텐츠번호',
                name: 'name',
                minWidth: 100
            },
            {
                header: '컨텐츠명',
                name: 'artist',
                minWidth: 120
            },
            {
                header: '카테고리',
                name: 'type',
                minWidth: 120
            },
            {
                header: '관련태그',
                name: 'release',
                minWidth: 120
            },
            {
                header: '공개여부',
                name: 'genre',
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



});