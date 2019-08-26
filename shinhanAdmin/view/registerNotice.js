

 $(document).ready(function (){
    
    /** start of components ***********************/
    $('#showYN').selectpicker();

    $('#uploaddate').datepicker();
    $('#showstart').datepicker();
    $('#showfinish').datepicker();



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

    resizeFrame();

});