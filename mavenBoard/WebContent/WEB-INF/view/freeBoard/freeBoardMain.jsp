<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>

<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
	<title>Insert title here</title>
</head>

<body>

	<div>
		<h1>자유게시판</h1>
	</div>
	<div align="left">
		<form name="searchForm">
			<div>
				<input type="date" name="startDate">~<input type="date" name="endDate">
			</div>
			<div>
				<select name="searchType" size="1">
					<c:forEach items="${searchList}" var="search">
						<c:if test="${search.CODE == 'COM001'}">
							<option value="${search.DETAIL_CODE}">${search.DETAIL_CODE_NAME}</option>
						</c:if>
					</c:forEach>
				</select>
				<input type="text" name="keyword" value="${keyword}" />
				<input type="button" id="btnSearch" value="검색">
			</div>
		</form>
	</div>
	<div style="width:650px;" align="right">
		<a href="./freeBoardInsert.ino">글쓰기</a>
	</div>
	<hr style="width: 600px">
	<div id="listBoard">
		<c:forEach items="${freeBoardList }" var="dto">
			<div style="width: 50px; float: left;">${dto.num }</div>
			<div style="width: 300px; float: left;"><a href="./freeBoardDetail.ino?num=${dto.num }">${dto.title }</a></div>
			<div style="width: 150px; float: left;">${dto.name }</div>
			<div style="width: 150px; float: left;">${dto.regdate }</div>
			<hr style="width: 600px">
		</c:forEach>
	</div>
	<div id="paging">
		<c:if test="${page.curPage > 1}">
			<a href="./main.ino?curPage=1">[처음]</a>
		</c:if>
		<c:if test="${page.curBlock > 1}">
			<a href="./main.ino?curPage=${prevPage}">[이전]</a>
		</c:if>
		<c:forEach var="pageNum" begin="${page.blockBegin}" end="${page.blockEnd}">
			<c:choose>
				<c:when test="${pageNum == page.curPage}">
					<span style="color: red">${pageNum}</span>&nbsp;
				</c:when>
				<c:otherwise>
					<a href="./main.ino?curPage=${pageNum}">${pageNum}</a>&nbsp;
				</c:otherwise>
			</c:choose>
		</c:forEach>
		<c:if test="${page.curBlock <= page.totalBlock}">
			<a href="./main.ino?curPage=${page.nextPage}">[다음]</a>
		</c:if>
		<c:if test="${page.curPage lt page.totalPage}">
			<a href="./main.ino?curPage=${page.totalPage}">[끝]</a>
		</c:if>
	</div>

	<script>
		// input 엔터 submit 방지
		$('input[type="text"]').keydown(function () {
			if (event.keyCode === 13) {
				doSearch();
				event.preventDefault();
			}
		});

		$("#btnSearch").click(function () {
			doSearch(1);
		});

		function doSearch(curPage) {

			var searchData = $('[name=searchForm]').serialize();
			if (curPage) {
				searchData += '&curPage=' + curPage;
			}
			$.ajax({
				url: 'searchResult.ino',
				type: 'post',
				data: searchData,
				success: function (data) {

					if (data.list == 0) {
						alert("검색 결과가 없습니다.");
						return;
					}

					$("#listBoard").empty();
					$("#paging").empty();
					var a = '';
					var page = data.page;
					$.each(data.list, function (key, value) {
						a += '<div style="width: 50px; float: left;">' + value.num + '</div>';
						a += '<div style="width: 300px; float: left;"><a href="./freeBoardDetail.ino?num=' + value
							.num + '">' + value.title + '</a></div>';
						a += '<div style="width: 150px; float: left;">' + value.name + '</div>';
						a += '<div style="width: 150px; float: left;">' + value.regdate + '</div>';
						a += '<hr style="width: 600px">';
					});
					$("#listBoard").append(a);
					var b = '';
					if (page.curPage > 1) {
						b += '<a href="javascript:void(0);" onclick="doSearch(1);">[처음]</a>';
					}
					if (page.curBlock > 1) {
						b += '<a href="javascript:void(0);" onclick="doSearch(' + page.prevPage + ');">[이전]</a>';
					}
					for (let index = page.blockBegin; index <= page.blockEnd; index++) {
						if (page.curPage == index) {
							b += '<span style="color: red">' + index + '</span>&nbsp;';
						} else {
							b += '<a href="javascript:void(0);" onclick="doSearch(' + index + ');">' + index +
								'</a>&nbsp;';
						}
					}
					if (page.curBlock <= page.totalBlock) {
						b += '<a href="javascript:void(0);" onclick="doSearch(' + page.nextPage + ')">[다음]</a>';
					}
					if (page.curPage < page.totalPage) {
						b += '<a href="javascript:void(0);" onclick="doSearch(' + page.totalPage + ');">[끝]</a>';
					}
					$("#paging").append(b);
				}
			});
		};
	</script>
</body>

</html>