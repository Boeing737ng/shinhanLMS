
$(document).ready(function () {

 
    $('#date').datepicker();
    $('#searchCategory').selectpicker();

    $.datepicker.setDefaults({
        dateFormat: 'yy-mm-dd' //Input Display Format 변경
    });


    /* var tree = [
        {
          text: "Parent 1",
          id: 'p1',
          nodes: [
            {
              text: "Child 1",
              id: 'c1',
              nodes: [
                {
                  text: "Grandchild 1"
                },
                {
                  text: "Grandchild 2"
                }
              ]
            },
            {
              text: "Child 2"
            }
          ]
        },
        {
          text: "Parent 2"
        },
        {
          text: "Parent 6"
        },
        {
            text: "Parent 7"
          },
          {
            text: "Parent 8"
          },
        {
          text: "Parent 4"
        },
        {
          text: "Parent 5"
        }
      ]; */

      var data = [
        {
            name: 'node1',
            children: [
                { name: 'child1' },
                { name: 'child2' }
            ]
        },
        {
            name: 'node2',
            children: [
                { name: 'child3' }
            ]
        }
    ];

      
    /* var treeView = $('#tree').treeview({
        data: tree,
        //color: "#428bca",
          expandIcon: "fas fa-plus",
          collapseIcon: "fas fa-minus",
          nodeIcon: "glyphicon glyphicon-user",
          showTags: true
    }); */

    var treeView = $('#tree').tree({
        data: [],
        closedIcon: '+',
        headers: {'abc': 'def'}
    });


    treeView.on('tree.select', function(e){
        //alert('ss');
        console.log(e.node);
        /* if (typeof node['nodes'] != "undefined") {
            var children = node['nodes'];
            for (var i=0; i<children.length; i++) {
                caseview.treeview('selectNode', [children[i].nodeId, { silent: true } ]);
            }
        } */
    });


    $('#btnSearch').on('click', function(e) {
        $('#tree').tree('loadData', []);
        fnRetrieve();
    });


    $('#btnAdd').on('click', function(e) {
        e.preventDefault();

        //console.log(node);

        /* var nodeName = $('#nodeName').val();
        var parentNode = $("#tree").tree("getSelectedNode");

        if(parentNode) {
            $("#tree").tree("appendNode", 
                {
                    label: nodeName,
                    id: 456
                },
                parentNode   // 이 항목을 제거하면 루트에 추가된다.
            );
        }else {
            $("#tree").tree("appendNode", 
                {
                    label: nodeName,
                    id: 456
                }
            );
        } */


        var parentNode = $("#tree").tree("getSelectedNode");
        console.log(parentNode);
        var parentNodeId = parentNode ? parentNode.id : 'root';

        $('#parentNode').val(parentNode.name);
        $('#parentNode').attr('data-id', parentNodeId);

    });


    function removeChildren(node) {
        if (node.children) {
            for (var i=node.children.length-1; i >= 0; i--) {
                var child = node.children[i];
                $('#tree').tree('removeNode', child);
            }
        }
    }


    function fnSave() {
        var nodeName = $('#nodeName').val();
        var parentNode = $("#tree").tree("getSelectedNode");
        var sortNum = $('#sortNum').val();
        var parentNodeId = parentNode ? parentNode.id : 'root';


        parent.database.ref( '/' + '신한은행' + '/categories/').push({
            'title': nodeName,
            'parent': parentNode.id,
            'sortNum': sortNum
        }).then(function onSuccess(res) {
            if(callback != null && callback != undefined) {
                callback();
            }
        }).catch(function onError(err) {
            console.log("ERROR!!!! " + err);
        });

        //var parentNode = $("#tree").tree("getNodeById", parentIdx);
    }


    function fnRetrieve() {
        var searchCompany = '신한은행';

        parent.database.ref('/'+ searchCompany+'/categories').once('value').then(function(snapshot) {
    
            var catArr = snapshot.val();
            var rsltArr = [];

            //console.log(catArr);

            $.each(catArr, function(idx, catObj) {

                console.log(idx);
                console.log(catObj);
                 
                var nodeName = catObj['title'];
                var parentIdx = catObj['parent'];
                var parentNode = $("#tree").tree("getNodeById", parentIdx);
                
                if(parentIdx == 'root') {
                    $("#tree").tree("appendNode", 
                        {
                            label: nodeName,
                            id: idx
                        }
                    );
                }else {
                    $("#tree").tree("appendNode", 
                        {
                            label: nodeName,
                            id: idx
                        },
                        parentNode   // 이 항목을 제거하면 루트에 추가된다.
                    );
                }
            });
    
        });
    }


    function fnValidate() {
        var errMsg = '';
        var param = '';
        var target;
        
        if(isEmpty($('#nodeName').val())) {

        }else if(isEmpty($('#parentNode').attr('data-id'))) {

        }else if(isEmpty($('#sortNum').val())) {

        }
    }



    resizeFrame();
 
});