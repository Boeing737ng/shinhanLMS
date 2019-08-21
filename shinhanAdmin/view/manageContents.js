

$('#contentDiv').off('load').on('load', function () {

    /** start of components ***********************/
    $('#searchOpenYn').selectpicker();
    $('#searchCategory').selectpicker();
    $('#searhRelatedTag').selectpicker();


    //행추가 버튼
    $('#btnAdd').on('click', function(e) {
        e.preventDefault();
        
        grid.appendRow({
            thumbnail: '',
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


    //저장 버튼
    $('#btnSave').on('click', function(e) {
        e.preventDefault();
        
        if(!grid.isModified()) {
            alert('저장할 데이터가 없습니다.');
            return false;
        }

        if(confirm('저장하시겠습니까?')) {
            var modifiedRecords = grid.getModifiedRows();
            console.log(modifiedRecords);
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
                header: '썸네일',
                name: 'thumbnail',
                minWidth: 120
            },
            {
                header: '컨텐츠명',
                name: 'artist',
                minWidth: 120
            },
            {
                header: '강사명',
                name: 'name',
                minWidth: 100
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
                align: 'center',
                minWidth: 70,
                onBeforeChange(ev){
					console.log('Before change:' + ev);
				},
				onAfterChange(ev){
					console.log('After change:' + ev);
				},
				formatter: 'listItemText',
				editor: {
					type: 'select',
					options: {
						listItems: [
							{ text: 'Y', value: 'Y' },
							{ text: 'N', value: 'N' }
						]
					}
				}
            }
        ]
    });


    grid.on('edit', function() {
        console.log('changed');
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


    //function fnLoadGridData(url, )



});