

$(document).ready(function () {

    /** start of components ***********************/
    $('#searchOpenYn').selectpicker();
    $('#searchCategory').selectpicker();
    $('#searhRelatedTag').selectpicker();

    $('#contentModal select.releaseYn').selectpicker();
    $('#contentModal select.category').selectpicker();
    

    //검색 버튼
    $('#btnSearch').on('click', function(e) {
        e.preventDefault();
        fnRetrieve();
    });


    //행추가 버튼
    $('#btnAdd').on('click', function(e) {
        e.preventDefault();
        window.location.href = "/view/registerContent.html";
        
        /* 
        
        grid.appendRow({
            thumbnail: '',
            author: '',
            title: '',
            tags: '',
            category: '',
            releaseYn: ''
        }, {focus: true}); */
    });


    //행삭제 버튼
    $('#btnDel').on('click', function(e) {
        e.preventDefault();

        alert('TO DO');
        return;
        
        if(grid.getCheckedRows().length == 0) {
            alert('선택된 데이터가 없습니다.');
            return false;
        }

        if(confirm("삭제하시겠습니까?")) {
            alert('TO DO');
            //grid.removeCheckedRows();
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
            //{ name: "Name", type: "text", width: 150, validate: "required" },
            {
                /* headerTemplate: function() {
                    return $("<input>").attr("type", "checkbox").text("X")
                    .on("change", function () {
                        if($(this).is(":checked")) {
                            $('tr.jsgrid-row input[type=checkbox].selectionCheckbox').each(function() {
                                console.log('ss');
                                $(this).prop('checked', true);
                                $(this).trigger('change');
                            });
                        }
                    });
                }, */
                itemTemplate: function(_, item) {
                    return $("<input>").attr("type", "checkbox")
                            .addClass('selectionCheckbox')
                            .prop("checked", $.inArray(item, selectedItems) > -1)
                            .on("change", function () {
                                $(this).is(":checked") ? selectItem(item) : unselectItem(item);
                            });
                },
                align: "center",
                width: 50
            },
            { name: "title", title: '컨텐츠명', type: "text", width: 150, editing: false },
            { name: "author", title: '강사명', type: "text", width: 120, editing: false },
            { name: "category", title: "카테고리", type: 'text', width: 200, editing: false },
            { name: "tags", title: "관련태그", type: 'text', width: 200, editing: false },
            { name: "releaseYn", title: "공개여부", type: 'select', items: ['Y', 'N'], width: 100 },
            { type: "control" } //edit control
        ]
    });


    
    
    
    //video load
    function fnLoadVideo(videoUrl) {
        var video = document.getElementById('video');
        video.pause();

        var source = document.createElement('source');
        source.type = 'video/mp4';
        source.src = videoUrl;

        video.innerHTML = '';
        video.appendChild(source);
        
        video.load();
    }
    /** end of grid *************************/


    fnRetrieve();

    
    //조회
    function fnRetrieve() {
        var searchReleaseYn = $('#searchOpenYn').val() || '';
        var searchCat = $('#searchCategory').val() || '';
        var searchTag = $('#searhRelatedTag').val() || '';
        var searchTitle = $('#searchTitle').val() || '';

        firebase.database().ref('/videos/').once('value').then(function(snapshot) {

            var catArr = snapshot.val();
            var rsltArr = [];
            
            $.each(catArr, function(idx, catObj) {
                var trgtTagArr = catObj['tags'].split(' ');

                if( 
                    ((searchReleaseYn == '') || (searchReleaseYn == catObj['releaseYn'])) &&
                    ((searchCat == '') || (searchCat == catObj['category'])) &&
                    ((searchTag == '') || (trgtTagArr.indexOf(searchTag) > -1)) &&
                    ((searchTitle == '') || (catObj['title'].indexOf(searchTitle)) > -1)
                ) {
                    rsltArr.push(catObj);
                }
            });

            $("#grid").jsGrid("option", "data", rsltArr);
            //$("#grid").jsGrid("refresh");
        });
    }


    var selectedItems = [];
 
    function selectItem(item) {
        selectedItems.push(item);
    };

    function unselectItem(item) {
        selectedItems = $.grep(selectedItems, function(i) {
            return i !== item;
        });
    };


    function deleteSelectedItems() {
        if(!selectedItems.length || !confirm("Are you sure?"))
            return;
 
        deleteClientsFromDb(selectedItems);
 
        var $grid = $("#jsGrid");
        $grid.jsGrid("option", "pageIndex", 1);
        $grid.jsGrid("loadData");
 
        selectedItems = [];
    };


    function fnGetCommonCmb(path, selector) {

        firebase.database().ref('/admin_menu/').once('value')
        .then(function (snapshot) {
            var menuArr = snapshot.val();
            var firstFlag = true;

            $.each(menuArr, function(idx, menuObj) {
                var newLi = $('#accordionSidebar li.nav-item.dummy').clone();
                $(newLi).find('span').text(menuObj['title']);
                $(newLi).find('i').addClass(menuObj['icon']);
                $(newLi).find('a').attr('data-url', menuObj['url']);

                $(newLi).removeClass('dummy');
                $(newLi).insertBefore('#accordionSidebar hr.sidebar-divider.d-none');

                if(firstFlag) {
                    $(newLi).addClass('active'); 
                    firstFlag = false;
                    //fnLoadPage(menuObj['title'], menuObj['url']);
                }
            });
        });

        $('' + selector).selectpicker();
    }


    //ifame height resize
    resizeFrame();

});