<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
        "http://www.w3.org/TR/html4/loose.dtd"><html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>MovieDB</title>
</head>
<body>
   <table border="1" cellpadding="5" cellspacing="5">
        <tr>
            <th>Title</th>
            <th>Director</th>
            <th>Year</th>
        </tr>
        <c:forEach var="entry" items="${list}">
            <tr>
                <td>${entry.title}</td>
                <td>${entry.director}</td>
                <td>${entry.year}</td>
            </tr>
        </c:forEach>
    </table>
	</body>
</html>