$(document).ready(function() {


    
/** start of grid ***********************/
$("#grid1").jsGrid({
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

    rowClick: function(args) {
        //showDetailsDialog("Edit", args.item);
        var arr = $('#grid1').jsGrid('option', 'data');
        var videoUrl = arr[args.itemIndex]['downloadURL'];
        fnLoadVideo(videoUrl);
    },
    fields: [
        { name: "name", title: '스터디명', type: "text", width: 120, editing: false, align: "center" },
        { name: "creator", title: "개설자", type: 'text', width: 150, editing: false, align: "center" },
        { name: "date", title: "등록일자", type: 'text', width: 150, editing: false, align: "center" },
      
    ]
    
});

$("#grid2").jsGrid({
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

    rowClick: function(args) {
        //showDetailsDialog("Edit", args.item);
        var arr = $('#grid2').jsGrid('option', 'data');
        var videoUrl = arr[args.itemIndex]['downloadURL'];
        fnLoadVideo(videoUrl);
    },
    fields: [
        { name: "name", title: '제목', type: "text", width: 120, editing: false, align: "center" },
        { name: "writor", title: "작성자", type: 'text', width: 150, editing: false, align: "center" },
        { name: "date", title: "등록일자", type: 'text', width: 150, editing: false, align: "center" },
      
    ]
    
});






    //resize frame height
    resizeFrame();
});
