
$(document).ready(function () {

 
    $('#date').datepicker();
    $('#searchCategory').selectpicker();

    $.datepicker.setDefaults({
        dateFormat: 'yy-mm-dd' //Input Display Format 변경
    });

    $("#grid").jsGrid({
        width: "100%",
        height: "500px",
        inserting: true,
        editing: true,
        sorting: true,
        paging: false,
        //filtering: true,
        data: [],
    
        insertcss: 'editRow',
    
        //data: clients,
    
        rowClick: function(args) {
            //showDetailsDialog("Edit", args.item);
            var arr = $('#grid').jsGrid('option', 'data');
            var videoUrl = arr[args.itemIndex]['downloadURL'];
            fnLoadVideo(videoUrl);
        },
        fields: [
            { name: "name", title: '카테고리번호', type: "text", width: 120, editing: false, align: "center" },
            { name: "creator", title: "카테고리명", type: 'text', width: 150, editing: false, align: "center" },
            { name: "date", title: "수강신청", type: 'text', width: 150, editing: false, align: "center" },
            { type: 'control'}
        ]
        
    });


    resizeFrame();
 
});