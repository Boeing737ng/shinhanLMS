

$('#contentDiv').off('load').on('load', function () {

    /** start of components ***********************/
    $('#searchOpenYn').selectpicker();
    $('#searchCategory').selectpicker();
    $('#searhRelatedTag').selectpicker();


    $('#searchRegDate')


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
    var grid = new tui.Grid({
        el: document.getElementById('grid'),
        rowHeaders: ['checkbox', 'rowNum'],
        data: [],
        bodyHeight: 500,
        scrollX: false,
        scrollY: true,
        columns: [
            {
                header: '스터디명',
                name: 'name',
                minWidth: 100
            },
            {
                header: '관련태그',
                name: 'release',
                minWidth: 120
            },
            {
                header: '개설자',
                name: 'creator',
                minWidth: 120
            },
            {
                header: '등록일자',
                name: 'date',
                minWidth: 120
            },
            {
                header: '참여자수',
                name: 'participant',
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