//获取url  上请求的  keyword=
var kv = window.location.search;
var v = kv.split("=")[1];   //获取传递的value值

//要进行编码之后回显
v = decodeURI(v);
//alert(v);
v = v.replace(/\+/g," ");
v = v.replace(/\%2B/g,"+");


//2.1回显数据
$("#inputSeach").val(v);

//发送异步请求
//ajaxQuery();
pageQuery(1, 10);


//新的发送异步的请求的方法
function pageQuery(page, pageSize) {
    //获取查询的条件
    var dateStart = $("[name=dateStart]").val();
    var dateEnd = $("[name=dateEnd]").val();
    var editor = $("#editor").val();
    var source = $("#source").val();

    //封装分页的查询条件
    var params = {
        'keywords': v,
        'startTime': dateStart,
        'endTime': dateEnd,
        'editor': editor,
        'source': source,
        'pageBean.page': page,
        'pageBean.pageSize': pageSize
    };

    //ajax发送请求
    $.post('/ps.action', params, function (data) {  //data获取的是resultbean
        var html = "";
        $(data.pageBean.newsList).each(function () {
            var docurl = this.docurl;
            //alert(docurl);
            docurl = docurl.substring(7, 20);
            html += "<div class=\"item\">\n" +
                "\t\t\t\t<div class=\"title\"><a href=\"" + this.docurl + "\">" + this.title + "</a></div>\n" +
                "\t\t\t\t<div class=\"contentInfo_src\">\n" +
                "\t\t\t\t\t<a href=\"#\"><img src=\"./img/item.jpeg\" alt=\"\" class=\"imgSrc\" width=\"121px\" height=\"75px\"></a>\n" +
                "\t\t\t\t\t<div class=\"infoBox\">\n" +
                "\t\t\t\t\t\t<p class=\"describe\">\n" +
                "\t\t\t\t\t\t\t" + this.content + "\n" +
                "\t\t\t\t\t\t</p>\n" +
                "\t\t\t\t\t\t<p><a class=\"showurl\" href=\"" + this.docurl + "\">" + docurl + " " + this.time + "</a> <span class=\"lab\">" + this.editor + " - " + this.source + "</span></p>\n" +
                "\t\t\t\t\t</div>\n" +
                "\t\t\t\t</div>\n" +
                "\t\t\t</div>";


        })
        //将获取的数据追加到页面中
        $(".itemList").html(html);

        //data 返回的数据就是  resultBean  从中可以获取到分页的总页数  和  当前页  以及  每页显示的条数
        //生成分页的工具条
        var pageNum = data.pageBean.pageNum;  //获取总页数
        var start = 1;    //起始的默认为1
        var end = pageNum; //最后的设置为总页码
        //判断怎样显示
        //前提是总页码不少于7的时候才进行判断  否则不用
        if (pageNum > 7) {
            if (page <= 4) {
                //显示前七页
                end = 7;
            }else if(page >= pageNum -3) {   //显示后7页
                start = pageNum - 6;
            }else {
                //除此之外  的都是显示  前三后三的显示形式
                start = page - 3;
                end = page + 3;
            }
        }

        //循环的将7位的页码进行显示
        var html = "<ul>";
        if (page != 1) {
            html += " <li><a href=\"javascript:void(0)\" onclick='pageQuery("+parseInt(page-1)+","+pageSize+")'>< 上一页</a></li>";
        }
        for (var i = start; i <= end; i++) {
            //i就代表7为的页码
            //进行当前页码选中的判断
            if(page == i) {
                html += "  <li class=\"on\">"+ i +"</li>";
            }else {
                //不是当前页的时候才能过选中跳转
                html += "  <li><a href='javascript:void(0)' onclick='pageQuery("+i+","+pageSize+")' >"+ i +"</a></li>";
            }
        }
        if (page != pageNum) {
            html += " <li><a href='javascript:void(0)' onclick='pageQuery("+parseInt(page+1)+","+pageSize+")'>下一页 ></a></li>";
        }

        html += " </ul> ";

        //追加到html中
        $(".pageList").html(html);

    }, 'json')

}

function topKeyQuery(num) {
    var url = "/top.action";
    $.post(url,{"num":num},function (data) {    //返回maplist数据

        var html = ""
        //遍历maplist
        $(data).each(function () {
            html += "<div class=\"item\" onclick='ajaxTop(this)'><span>"+this.topkey+"</span> <span style='float: right;color: red'>"+this.score+"</span></div>";
        })

        $(".recommend").html(html);

    },"json")
}

function ajaxTop(obj) {
    var topkey = $(obj).children(":first").text();

    location.href = "/list.html?keywords=" + topkey;

}
