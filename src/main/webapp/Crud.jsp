<%@page import="model.Task"%>
<%@page import="java.util.List"%>
<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Task Management</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f9f9f9;
        }

        .title-div {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 20px;
            background-color: #007BFF;
            color: white;
        }

        .title-div h1 {
            margin: 0;
        }

        .title-div a {
            color: white;
            text-decoration: none;
            font-weight: bold;
            margin-left: 15px;
        }

        .title-div a:hover {
            text-decoration: underline;
        }

        .form-container {
            padding: 20px;
            background-color: white;
            margin: 20px auto;
            border: 1px solid #ddd;
            border-radius: 8px;
            width: 80%;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }

        .form-container form label {
            display: block;
            margin-bottom: 8px;
            font-weight: bold;
        }

        .form-container form input {
            width: 100%;
            padding: 8px;
            margin-bottom: 20px;
            border: 1px solid #ddd;
            border-radius: 4px;
        }

        .form-container button {
            background-color: #007BFF;
            color: white;
            border: none;
            padding: 10px 20px;
            cursor: pointer;
            border-radius: 4px;
            font-size: 16px;
        }

        .form-container button:hover {
            background-color: #0056b3;
        }

        table {
            width: 80%;
            margin: 20px auto;
            border-collapse: collapse;
            background-color: white;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            border-radius: 8px;
            overflow: hidden;
        }

        table th, table td {
            border: 1px solid #ddd;
            text-align: left;
            padding: 12px;
        }

        table th {
            background-color: #f2f2f2;
            font-weight: bold;
        }

        table tr:nth-child(even) {
            background-color: #f9f9f9;
        }

        table tr:hover {
            background-color: #f1f1f1;
        }

        .details-card {
            display: none;
            margin: 20px auto;
            padding: 20px;
            width: 80%;
            border: 1px solid #ddd;
            border-radius: 8px;
            background-color: white;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }

        .details-card h2 {
            margin-top: 0;
            color: #333;
        }

        .details-card p {
            margin: 8px 0;
            font-size: 16px;
        }

        .details-card button {
            background-color: #007BFF;
            color: white;
            border: none;
            padding: 8px 16px;
            cursor: pointer;
            border-radius: 4px;
            font-size: 14px;
        }

        .details-card button:hover {
            background-color: #0056b3;
        }
    </style>
</head>
<body>
    <div class="title-div">
        <h1>Task Management</h1>
        <div>
            <a href="DashBoard.jsp">Go to Dashboard</a>
            <a href="logout">Logout</a>
        </div>
    </div>

    <!-- Success or Failure Messages -->
    <div id="successMessage" style="color: green; text-align: center;">
        <% 
            String successMessage = (String) session.getAttribute("successMessage");
            if (successMessage != null) { 
        %>
            <p><%= successMessage %></p>
        <% } %>
    </div>

    <div id="failureMessage" style="color: red; text-align: center;">
        <% 
            String failureMessage = (String) session.getAttribute("failureMessage");
            if (failureMessage != null) { 
        %>
            <p><%= failureMessage %></p>
        <% } %>
    </div>

    <div class="form-container">
        <form action="addTask" method="post">
            <input type="hidden" name="action" value="create">
            <input type="hidden" name="taskId" id="taskId">
            <label for="taskName">Task Name:</label>
            <input type="text" id="taskName" name="taskName" required>
            <label for="taskDesc">Task Description:</label>
            <input type="text" id="taskDesc" name="taskDesc" required>
            <button type="submit" id="submitButton">Add Task</button>
        </form>
    </div>

    <% 
        List<Task> tasks = (List<Task>) session.getAttribute("tasks");
        boolean isAdmin = (boolean) session.getAttribute("isAdmin");

        if (tasks != null && !tasks.isEmpty()) {
    %>
        <table>
            <tr>
                <th>ID</th>
                <th>Task Name</th>
                <th>Description</th>
                <% if (isAdmin) { %>
                <th>User Name</th>
                <% } %>
                <th>Action</th>
            </tr>
            <% for (Task task : tasks) { %>
            <tr>
                <td><%= task.getId() %></td>
                <td><%= task.getTaskname() %></td>
                <td><%= task.getDesc() %></td>
                <% if (isAdmin) { %>
                <td><%= task.getUserName() %></td>
                <% } %>
                <td>
                    <button onclick="showDetails('<%= task.getId() %>', '<%= task.getTaskname().replace("'", "\\'") %>', '<%= task.getDesc().replace("'", "\\'") %>')">Details</button>
                    <button onclick="editTask(<%= task.getId() %>, '<%= task.getTaskname().replace("'", "\\'") %>', '<%= task.getDesc().replace("'", "\\'") %>')">Edit</button>
                    <form action="delete" method="post" style="display:inline;">
                        <input type="hidden" name="taskId" value="<%= task.getId() %>">
                        <button type="submit">Delete</button>
                    </form>
                </td>
            </tr>
            <% } %>
        </table>
    <% } else { %>
        <p style="text-align: center;">No tasks yet.</p>
    <% } %>

    <div class="details-card" id="detailsCard">
        <h2>Task Details</h2>
        <p><strong>ID:</strong> <span id="detailsId"></span></p>
        <p><strong>Name:</strong> <span id="detailsName"></span></p>
        <p><strong>Description:</strong> <span id="detailsDesc"></span></p>
        <button onclick="hideDetails()">Close</button>
    </div>

    <script>
        function editTask(id, name, desc) {
            document.getElementById('taskId').value = id;
            document.getElementById('taskName').value = name;
            document.getElementById('taskDesc').value = desc;
            document.getElementById('submitButton').innerText = 'Update Task';
            document.querySelector('form').action = 'update';
        }

        function showDetails(id, name, desc) {
            document.getElementById('detailsId').innerText = id;
            document.getElementById('detailsName').innerText = name;
            document.getElementById('detailsDesc').innerText = desc;
            document.getElementById('detailsCard').style.display = 'block';
        }

        function hideDetails() {
            document.getElementById('detailsCard').style.display = 'none';
        }
    </script>
</body>
</html>
