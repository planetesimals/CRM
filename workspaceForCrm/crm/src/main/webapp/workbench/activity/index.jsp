<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + "/";
%>
<!DOCTYPE html>
<html>
<head>
	<base href="<%=basePath%>">
<meta charset="UTF-8">

	<!--插件的加载也是需要顺序的，顺序不能改变，先jquery,再bootstrap,然后才能是bootstrap-datetimepicker的插件，先有主题，才能有补充-->

<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
<link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />
<!--时间控件，主要是下拉框显示年月日等时间-->
<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
<!--先有bootstrap主体，再有jquery.bs_pagination.min.js插件，要注意顺序-->
	<link rel="stylesheet" type="text/css" href="jquery/bs_pagination/jquery.bs_pagination.min.css">
	<script type="text/javascript" src="jquery/bs_pagination/jquery.bs_pagination.min.js"></script>
	<script type="text/javascript" src="jquery/bs_pagination/en.js"></script>


<script type="text/javascript">

	$(function(){
		
		//为创建按钮绑定事件，打开添加操作的模态窗口
		$("#addBtn").click(function () {

			<!--日期下拉框显示年月日，导入插件后可以直接使用这段代码  .time用class引-->
			$(".time").datetimepicker({
				minView: "month",
				language:  'zh-CN',
				format: 'yyyy-mm-dd',
				autoclose: true,
				todayBtn: true,
				pickerPosition: "bottom-left"
			});

			/*

				操作模态窗口的方式，

				需要操作的模态窗口的jquery对象，调用modal方法，为该方法传递参数 show:打开模态窗口  hide:关闭模态窗口

			 */

			//alert(123);
			//$("#createActivityModal").modal("show");

			//走后台，目的是为了取得用户信息列表，为所有者下拉框铺值
			$.ajax({

				url : "workbench/activity/getUserList.do",
				type : "get",
				dataType : "json",
				success : function (data) {

				/*
					用户信息列表在后台被处理成了
					List<User> uList
					data
						json形式 [{"id":?,"name":?,"loginAct":?.......},{2},{3}...]

				 */

					var html = "<option></option>";

					//遍历出来的每一个n,就是每一个user对象
					$.each(data,function (i,n) {

						//拼字符串的形式拼option，option里面的内容就是给用户看的文本信息
						html += "<option value='"+n.id+"'>"+n.name+"</option>";

					})

					$("#create-owner").html(html);


					//将当前登录的用户，设置为下拉框默认的选项
					/*

						<select id="create-owner">
							<option value="40f6cdea0bd34aceb77492a1656d9fb3">张三</option>
							<option value="06f5fc056eac41558a964f96daa7f27c">李四</option>
						</select>

						$("#create-owner").val("40f6cdea0bd34aceb77492a1656d9fb3");


					 */

					//取得当前登录用户的id
					//在js中使用el表达式，el表达式一定要套用在字符串中
					var id = "${user.id}";

					$("#create-owner").val(id);
					//所有者下拉框处理完毕后，展现模态窗口
					$("#createActivityModal").modal("show");



				}

			})



		})

        //为保存按钮绑定事件，执行添加操作
        $("#saveBtn").click(function () {

            $.ajax({

                url : "workbench/activity/save.do",
                data : {

                    "owner" : $.trim($("#create-owner").val()),
                    "name" : $.trim($("#create-name").val()),
                    "startDate" : $.trim($("#create-startDate").val()),
                    "endDate" : $.trim($("#create-endDate").val()),
                    "cost" : $.trim($("#create-cost").val()),
                    "description" : $.trim($("#create-description").val())

                },
                type : "post",
                dataType : "json",
                success : function (data) {

                    /*

                        data
                            {"success":true/false}

                     */
                    if(data.success){

                        //添加成功后
                        //刷新市场活动信息列表（局部刷新）
                        //pageList(1,2);

                        /*
                        * $("#activityPage").bs_pagination('getOption', 'currentPage'):
                        * 		操作后停留在当前页
                        *
                        * $("#activityPage").bs_pagination('getOption', 'rowsPerPage')
                        * 		操作后维持已经设置好的每页展现的记录数
                        * 这两个参数不需要我们进行任何的修改操作
                        * 	直接使用即可
                        * */

                        //做完添加操作后，应该回到第一页，维持每页展现的记录数
                         pageList(1,$("#activityPage").bs_pagination('getOption', 'rowsPerPage'));
                        //清空添加操作模态窗口中的数据
                        //提交表单
                        //$("#activityAddForm").submit();

						//$("#activityAddForm").reset();  虽然IDEA里有这个方法，但它是个无效方法
                        /*

                            注意：
                                我们拿到了form表单的jquery对象  $("#activityAddForm")
                                对于表单的jquery对象，提供了submit()方法让我们提交表单
                                但是表单的jquery对象，没有为我们提供reset()方法让我们重置表单（坑：idea为我们提示了有reset()方法）

                                虽然jquery对象没有为我们提供reset方法，但是原生js为我们提供了reset方法
                                所以我们要将jquery对象转换为原生dom对象

                                jquery对象如何转换为dom对象： jquery对象可以当做dom对象的数组来使用
                                    jquery对象[下标]

                                dom对象如何转换为jquery对象：
                                    $(dom)

                         */
						//重置表单
                         $("#activityAddForm")[0].reset();

                        //关闭添加操作的模态窗口
                        $("#createActivityModal").modal("hide");

                    }else{

                        alert("添加市场活动失败");

                    }

                }

            })
        })
		//页面加载完毕后触发一个方法
		//默认展开列表的第一页，每页展现两条记录
		pageList(1,2);

		//为查询按钮绑定事件，触发pageList方法
		$("#searchBtn").click(function () {

			/*
				点击查询按钮的时候，我们应该将搜索框中的信息保存起来,保存到隐藏域中

			 */

			$("#hidden-name").val($.trim($("#search-name").val()));
			$("#hidden-owner").val($.trim($("#search-owner").val()));
			$("#hidden-startDate").val($.trim($("#search-startDate").val()));
			$("#hidden-endDate").val($.trim($("#search-endDate").val()));

			pageList(1,2);

		})

		//为全选的复选框绑定事件，触发全选操作,qx是全选框，xz是每个等待被选择的框，this表示全选的dom对象（qx)
		$("#qx").click(function () {

			$("input[name=xz]").prop("checked",this.checked);

		})
		//以下这种做法是不行的
		/*$("input[name=xz]").click(function()){
			alert(123);
		}*/
		//因为动态生成的元素，是不能够以普通绑定事件的形式来进行操作的
		/*
		动态生成的元素，我们要以on方法的形式来触发事件
		语法：
			$(需要绑定元素的有效的外层元素).on(绑定事件的方式，需要绑定的元素的jquery对象，回调函数)
		 */

		$("#activityBody").on("click",$("input[name=xz]"),function () {

			$("#qx").prop("checked",$("input[name=xz]").length==$("input[name=xz]:checked").length);

		})

		//为删除按钮绑定事件，执行市场活动删除操作
		$("#deleteBtn").click(function () {

			//找到复选框中所有挑√的复选框的jquery对象，jquery对象可以当做dom对象的数组使用
			var $xz = $("input[name=xz]:checked");

			if($xz.length==0){

				alert("请选择需要删除的记录");

				//肯定选了，而且有可能是1条，有可能是多条
			}else{

				if(confirm("确定删除所选中的记录吗？")){

					//url:workbench/activity/delete.do?id=xxx&id=xxx&id=xxx

					//拼接参数
					var param = "";
					//每一个被选中的框就是一个jquery对象
					//将$xz中的每一个dom对象遍历出来，取其value值，就相当于取得了需要删除的记录的id，$($xz[i])又被包装成了jquery对象，jquery对象取值用val取
					for(var i=0;i<$xz.length;i++){

						param += "id="+$($xz[i]).val();

						//如果不是最后一个元素，需要在后面追加一个&符
						if(i<$xz.length-1){

							param += "&";

						}

					}
					//ajax请求，局部刷新
					//alert(param);
					$.ajax({

						url : "workbench/activity/delete.do",
						data : param,
						type : "post",
						dataType : "json",
						success : function (data) {

							/*
                                data
                                    {"success":true/false}
                             */
							if(data.success){

								//删除成功后
								//回到第一页，维持每页展现的记录数
								pageList(1,$("#activityPage").bs_pagination('getOption', 'rowsPerPage'));


							}else{

								alert("删除市场活动失败");

							}
						}
					})
				}
			}
		})

		//为修改按钮绑定事件，打开修改操作的模态窗口,$xz中加了$符，就是jquery对象，为了和dom对象区分开
		$("#editBtn").click(function () {

			var $xz = $("input[name=xz]:checked");

			if($xz.length==0){

				alert("请选择需要修改的记录");

			}else if($xz.length>1){

				alert("只能选择一条记录进行修改");

				//肯定只选了一条，$xz.val()，因为jquery对象中只有一个dom对象，所以直接.val()就可以拿到这个对象，id就是挑勾的需要修改的那个id
			}else{

				var id = $xz.val();

				$.ajax({

					url : "workbench/activity/getUserListAndActivity.do",
					data : {

						"id" : id

					},
					type : "get",
					dataType : "json",
					success : function (data) {

						/*
							data
								用户列表
								市场活动对象
								{"uList":[{用户1},{2},{3}],"a":{市场活动}}
						 */

						//处理所有者下拉框
						var html = "<option></option>";

						$.each(data.uList,function (i,n) {

							html += "<option value='"+n.id+"'>"+n.name+"</option>";

						})
						$("#edit-owner").html(html);

						//处理单条activity
						$("#edit-id").val(data.a.id);
						$("#edit-name").val(data.a.name);
						$("#edit-owner").val(data.a.owner);
						$("#edit-startDate").val(data.a.startDate);
						$("#edit-endDate").val(data.a.endDate);
						$("#edit-cost").val(data.a.cost);
						$("#edit-description").val(data.a.description);

						//所有的值都填写好之后，打开修改操作的模态窗口
						$("#editActivityModal").modal("show");

					}

				})

			}

		})

		//为更新按钮绑定事件，执行市场活动的修改操作
		/*

			在实际项目开发中，一定是按照先做添加，再做修改的这种顺序
			所以，为了节省开发时间，修改操作一般都是copy添加操作

		 */
		$("#updateBtn").click(function () {

			$.ajax({

				url : "workbench/activity/update.do",
				data : {

					"id" : $.trim($("#edit-id").val()),
					"owner" : $.trim($("#edit-owner").val()),
					"name" : $.trim($("#edit-name").val()),
					"startDate" : $.trim($("#edit-startDate").val()),
					"endDate" : $.trim($("#edit-endDate").val()),
					"cost" : $.trim($("#edit-cost").val()),
					"description" : $.trim($("#edit-description").val())

				},
				type : "post",
				dataType : "json",
				success : function (data) {

					/*

						data
							{"success":true/false}

					 */
					if(data.success){

						//修改成功后
						//刷新市场活动信息列表（局部刷新）
						//pageList(1,2);
						/*

							修改操作后，应该维持在当前页，维持每页展现的记录数

						 */
						pageList($("#activityPage").bs_pagination('getOption', 'currentPage')
								,$("#activityPage").bs_pagination('getOption', 'rowsPerPage'));


						//关闭修改操作的模态窗口
						$("#editActivityModal").modal("hide");



					}else{

						alert("修改市场活动失败");

					}




				}

			})

		})


	});

	/*

		对于所有的关系型数据库，做前端的分页相关操作的基础组件
		就是pageNo和pageSize
		pageNo:页码
		pageSize:每页展现的记录数
		pageList方法：就是发出ajax请求到后台，从后台取得最新的市场活动信息列表数据
						通过响应回来的数据，局部刷新市场活动信息列表

		我们都在哪些情况下，需要调用pageList方法（什么情况下需要刷新一下市场活动列表）
		（1）点击左侧菜单中的"市场活动"超链接，需要刷新市场活动列表，调用pageList方法
		（2）添加，修改，删除后，需要刷新市场活动列表，调用pageList方法
		（3）点击查询按钮的时候，需要刷新市场活动列表，调用pageList方法
		（4）点击分页组件的时候，调用pageList方法

		以上为pageList方法制定了六个入口，也就是说，在以上6个操作执行完毕后，我们必须要调用pageList方法，刷新市场活动信息列表
	 */
	function pageList(pageNo,pageSize) {
		//将全选的复选框的√干掉
		$("#qx").prop("checked",false);

		//查询前，将隐藏域中保存的信息取出来，重新赋予到搜索框中
		$("#search-name").val($.trim($("#hidden-name").val()));
		$("#search-owner").val($.trim($("#hidden-owner").val()));
		$("#search-startDate").val($.trim($("#hidden-startDate").val()));
		$("#search-endDate").val($.trim($("#hidden-endDate").val()));
		$.ajax({

			url : "workbench/activity/pageList.do",
			data : {
				<!--前面两条记录是做分页查询的，，下面四个参数是做条件查询的-->
				"pageNo" : pageNo,
				"pageSize" : pageSize,
				"name" : $.trim($("#search-name").val()),
				"owner" : $.trim($("#search-owner").val()),
				"startDate" : $.trim($("#search-startDate").val()),
				"endDate" : $.trim($("#search-endDate").val())

			},
			type : "get",
			dataType : "json",
			success : function (data) {
				/*
					data
						我们需要的：市场活动信息列表
						[{市场活动1},{2},{3}] List<Activity> aList
						一会分页插件需要的：查询出来的总记录数
						{"total":100} int total
						多组键值对之间用，分隔
						{"total":100,"dataList":[{市场活动1},{2},{3}]}
				 */
				var html = "";
				//每一个n就是每一个市场活动对象，调用date.key的方式获取value,使用单引号拼接，否则内里的双引号会有歧义，当有歧义出现时，可以采用转义字符
				$.each(data.dataList,function (i,n) {

					html += '<tr class="active">';
					html += '<td><input type="checkbox" name="xz" value="'+n.id+'"/></td>';
					html += '<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href=\'workbench/activity/detail.do?id='+n.id+'\';">'+n.name+'</a></td>';
					html += '<td>'+n.owner+'</td>';
					html += '<td>'+n.startDate+'</td>';
					html += '<td>'+n.endDate+'</td>';
					html += '</tr>';

				})
				//调用.html方法，为标签对activityBody中的内容赋值
				$("#activityBody").html(html);

				//计算总页数
				var totalPages = data.total%pageSize==0?data.total/pageSize:parseInt(data.total/pageSize)+1;

				//数据处理完毕后，结合分页查询，对前端展现分页信息，插件都是直接拿来用的，不用去记,.bs_pagination方法是分页插件jquery.bs_pagination.min.js写的
				$("#activityPage").bs_pagination({
					currentPage: pageNo, // 页码
					rowsPerPage: pageSize, // 每页显示的记录条数
					maxRowsPerPage: 20, // 每页最多显示的记录条数
					totalPages: totalPages, // 总页数
					totalRows: data.total, // 总记录条数

					visiblePageLinks: 3, // 显示几个卡片

					showGoToPage: true,
					showRowsPerPage: true,
					showRowsInfo: true,
					showRowsDefaultInfo: true,

					//该回调函数时在，点击分页组件的时候触发的，data.currentPage , data.rowsPerPage这两个参数不能碰，这是前段分页插件给我们提供好的，data是人家自己的，不是前面自己写出来的data
					onChangePage : function(event, data){
						pageList(data.currentPage , data.rowsPerPage);
					}
				});


			}

		})

	}
	
</script>
</head>
<body>

	<input type="hidden" id="hidden-name"/>
	<input type="hidden" id="hidden-owner"/>
	<input type="hidden" id="hidden-startDate"/>
	<input type="hidden" id="hidden-endDate"/>

	<!-- 修改市场活动的模态窗口 -->
	<div class="modal fade" id="editActivityModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel2">修改市场活动</h4>
				</div>
				<div class="modal-body">

					<form class="form-horizontal" role="form">

						<input type="hidden" id="edit-id"/>

						<div class="form-group">
							<label for="edit-marketActivityOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-owner">

								</select>
							</div>
							<label for="edit-marketActivityName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-name">
							</div>
						</div>

						<div class="form-group">
							<label for="edit-startTime" class="col-sm-2 control-label">开始日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control time" id="edit-startDate">
							</div>
							<label for="edit-endTime" class="col-sm-2 control-label">结束日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control time" id="edit-endDate">
							</div>
						</div>

						<div class="form-group">
							<label for="edit-cost" class="col-sm-2 control-label">成本</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-cost">
							</div>
						</div>

						<div class="form-group">
							<label for="edit-describe" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<!--

									关于文本域textarea:
										(1)一定要以标签对的形式来呈现，不能闭合成<.../>,正常状态下标签对要紧紧挨着，中间不要留空位
										(2)textarea虽然是以标签对的形式来呈现的，但他也是属于表单元素范畴
											我们所有的对于textarea的取值和赋值操作，应该统一使用val()方法（而不是html()方法)

								-->
								<textarea class="form-control" rows="3" id="edit-description">123</textarea>
							</div>
						</div>

					</form>

				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="updateBtn">更新</button>
				</div>
			</div>
		</div>
	</div>

	<!-- 创建市场活动的模态窗口 -->
	<div class="modal fade" id="createActivityModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel1">创建市场活动</h4>
				</div>
				<div class="modal-body">
				
					<form id="activityAddForm" class="form-horizontal" role="form">
					
						<div class="form-group">
							<label for="create-marketActivityOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-owner">



								</select>
							</div>
                            <label for="create-marketActivityName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-name">
                            </div>
						</div>
						<!--同时为class加入多项信息，用空格进行分隔就行
						readonly只读，只能从选项中选，不能自己在文本框中输入
						-->
						<div class="form-group">
							<label for="create-startTime" class="col-sm-2 control-label">开始日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control time" id="create-startDate" readonly>
							</div>
							<label for="create-endTime" class="col-sm-2 control-label">结束日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control time" id="create-endDate" readonly>
							</div>
						</div>
                        <div class="form-group">

                            <label for="create-cost" class="col-sm-2 control-label">成本</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-cost">
                            </div>
                        </div>
						<div class="form-group">
							<label for="create-describe" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="create-description"></textarea>
							</div>
						</div>
						
					</form>
					
				</div>
				<div class="modal-footer">
					<!--
					data-dismiss="modal":
					    表示关闭模态窗口
					-->
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="saveBtn">保存</button>
				</div>
			</div>
		</div>
	</div>
	

	
	
	
	
	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>市场活动列表</h3>
			</div>
		</div>
	</div>
	<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
		<div style="width: 100%; position: absolute;top: 5px; left: 10px;">
		
			<div class="btn-toolbar" role="toolbar" style="height: 80px;">
				<form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">名称</div>
				      <input class="form-control" type="text" id="search-name">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">所有者</div>
				      <input class="form-control" type="text" id="search-owner">
				    </div>
				  </div>


				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">开始日期</div>
					  <input class="form-control" type="text" id="search-startDate" />
				    </div>
				  </div>
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">结束日期</div>
					  <input class="form-control" type="text" id="search-endDate">
				    </div>
				  </div>
				 <!--type="submit"是很危险的，相当于以传统方式提交这张表单，页面将会是全局刷新的操作,需要修改-->
				  <button type="button" id="searchBtn" class="btn btn-default">查询</button>
				  
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 5px;">
				<div class="btn-group" style="position: relative; top: 18%;">
					<!--

						点击创建按钮，观察两个属性和属性值
						data-toggle="modal"    表示触发该按钮将要打开一个模态窗口
						data-target="#createActivityModal"  表示要打开哪个模态窗口，通过以#id的形式找到该窗口

						现在我们是以属性和属性值的方式写在了button元素中，用来打开模态窗口
						但是这样做是有问题的，
						问题在于没有办法对按钮的功能进行扩充

						所以未来的实际项目开发，对于触发模态窗口的操作，一定不要写死在元素当中，
						应该由我们自己写js代码来操作

					-->

				  <button type="button" class="btn btn-primary" id="addBtn"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button type="button" class="btn btn-default" id="editBtn"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button type="button" class="btn btn-danger" id="deleteBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
				
			</div>
			<div style="position: relative;top: 10px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input type="checkbox" id="qx"/></td>
							<td>名称</td>
                            <td>所有者</td>
							<td>开始日期</td>
							<td>结束日期</td>
						</tr>
					</thead>
					<!--在js中动态地拼接tr和td，要写活-->
					<tbody id="activityBody">
						<%--<tr class="active">
							<td><input type="checkbox" /></td>
							<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='workbench/activity/detail.html';">发传单</a></td>
                            <td>zhangsan</td>
							<td>2020-10-10</td>
							<td>2020-10-20</td>
						</tr>
                        <tr class="active">
                            <td><input type="checkbox" /></td>
                            <td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.html';">发传单</a></td>
                            <td>zhangsan</td>
                            <td>2020-10-10</td>
                            <td>2020-10-20</td>
                        </tr>--%>
					</tbody>
				</table>
			</div>
			
			<div style="height: 50px; position: relative;top: 30px;">

				<div id="activityPage"></div>
			</div>
			
		</div>
		
	</div>
</body>
</html>