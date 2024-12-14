package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Task;

import java.io.IOException;
import java.sql.Connection;
import java.util.List;

import DB.DBConnection;


@WebServlet("/task")
public class TaskLoad extends HttpServlet {
	private static final long serialVersionUID = 1L;

    public TaskLoad() {
        super();
    }


	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		int userId = Integer.parseInt(request.getParameter("userId"));
		try{
			List<Task> tasks = ShowTaskList.showTasks(userId);
            request.getSession().setAttribute("tasks", tasks);
            request.getRequestDispatcher("Crud.jsp").forward(request, response);;
		}catch(Exception e) {
			e.printStackTrace();
		}
		
	}

}
