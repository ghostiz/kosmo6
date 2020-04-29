<%@page import="etc.PagingUtil"%>
<%@page import="practice.BoardDTO"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@page import="practice.BoardDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
	request.setCharacterEncoding("UTF-8");
	BoardDAO dao = new BoardDAO(application);
	Map map = new HashMap();
	String searchColumn = request.getParameter("searchColumn");
	String searchWord = request.getParameter("searchWord");
	String queryString = "";
	if(searchColumn != null){
		map.put("columnName",searchColumn);
		map.put("keyword",searchWord);
		queryString = String.format("searchColumn=%s&searchWord=%s&",searchColumn,searchWord);
	}
	int totalRecordCount = dao.totalRowCount(map);
	int pageSize = Integer.valueOf(application.getInitParameter("PAGE_SIZE"));
	int blockPage = Integer.parseInt(application.getInitParameter("BLOCK_PAGE"));
	int totalPage = (int)Math.ceil((double)totalRecordCount / pageSize);
	int nowPage = request.getParameter("nowPage") == null ? 1 : Integer.parseInt(request.getParameter("nowPage"));
	int start = (nowPage - 1) * pageSize + 1;
	int end = nowPage * pageSize;
	map.put("start",start);
	map.put("end",end);
	List<BoardDTO> list = dao.selectList(map);
	dao.close();


%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>BoardList.jsp</title>
<link href="<c:url value='/Bootstrap/css/bootstrap.min.css'/>" rel="stylesheet">
</head>
<body style="height:1000px;">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.2/jquery.min.js"></script>
<script src="<c:url value='/Bootstrap/js/bootstrap.min.js'/>"></script>
<!-- 상단 네비게이션바 -->
<nav class="navbar navbar-inverse navbar-fixed-top">

  <div class="container-fluid bg-primary  col-md-12"> 
    <div class="navbar-header">
      <button class="navbar-toggle collapsed" data-toggle="collapse" data-target="#navbar-1">
        <span class="sr-only">Toggle navigation</span>
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>
      </button>
      <a class="navbar-brand" href="#">
      <span class="glyphicon glyphicon-fire" aria-hidden="true"></span>
      HOME</a>
    </div>
    <div class="collapse navbar-collapse" id="navbar-1">
      <ul class="nav navbar-nav">
        <li><a href="Mypage.jsp">HOME</a></li>
        <li class="active"><a href="BoardList.jsp">BOARD</a></li>
        <% if(session.getAttribute("USER_ID")==null){ %>
        <li><a href="Signup.jsp">SIGNUP</a></li>
        <li><a href="Login.jsp">LOGIN</a></li> 
		<%} else{ %>
        <li><a href="Mypage.jsp">MYPAGE</a></li>
        <li><a href="Logout.jsp">LOGOUT</a></li>
        <% }%>
      </ul>
    </div><!-- /.navbar-collapse -->
  </div><!-- /.container-fluid -->
</nav>
		<!-- 아래는 div로 빈 공간 여백 추가-->
		<div class="clearfix">
			<span>&nbsp;</span>
		</div>

<!-- content -->
<div class="container-fluid bg-primary" style="height:100%;color:white;margin:0 auto">
		<div class="row" id="body" align="center" style="margin-top: 10%">	
			<div class="col-md-2"></div>
			<div class="col-md-8 text-right">
				<a href="<c:url value='BoardWrite.jsp'/>" class="btn btn-info" >등록</a>
			</div>
		</div>
	<div class="row" id="body" align="center" style="margin-top: 20px">		
		<div class="col-md-2"></div>
			<div class="col-md-8">
			<table class="table table-bordered table-condensed">
				<tr>
					<th class="col-md-1 text-center">No</th>
					<th class="col-md-4 text-center">Title</th>
					<th class="col-md-2 text-center">Name</th>
					<th class="col-md-1 text-center">Hit</th>
					<th class="col-md-2 text-center">Date</th>
				</tr>				
				<% if(list.isEmpty()){ %>
				<tr>
					<td class="text-center" colspan="5">등록된 글이 없엉 잇힝</td>
				</tr>			
				<%}
				else{
					int count =0;
					for(BoardDTO dto:list){							
				%>		
				<tr class="text-center">
				<td><%=totalRecordCount - (((nowPage-1)*pageSize)+count) %></td>
					<td class="text-left"><a style="color:white;"href="BoardView.jsp?<%=queryString %>nowPage=<%=nowPage %>&no=<%=dto.getNo() %>"><%=dto.getTitle() %></a></td>
					<td><%=dto.getName() %></td>
					<td><%=dto.getVisitCount() %></td>
					<td><%=dto.getPostDate() %></td>
				</tr>				
				<% count++; 
					}//for					
				}//else	%>							
				</table>	
				
				<table width="100%">
					<tr class="text-center">
<td><%=PagingUtil.pagingText(totalRecordCount,pageSize,blockPage,nowPage,"BoardList.jsp?"+queryString) %></td>					
					</tr>			
				</table>
				<br/>			
				<div class="row">
					<div class="col-md-2"></div>
					<div class="col-md-8">
							<form method="post">
							<table>
							<tr>
							<td>	<select name="searchColumn" class="form-control">
									<option value="title">제목</option>
									<option value="name">작성자</option>
									<option value="content">내용</option>						
								</select></td>
								 <td>	<input style="margin-left:10px" type="text" class="form-control" name="searchWord" placeholder="검색할 내용 입력"/></td>
									<td> <input style="margin-left:20px" type="submit" class="btn btn-danger" value="검색"/>		</td>							
							</tr>
							
							</table>
							</form>
						</div>
				</div>							
		</div>
	</div><!-- body -->
</div><!-- container -->

</body>
</html>
