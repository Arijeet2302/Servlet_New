package controller;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import DB.DBConnection;
import model.Task;
import util.CheckAdmin;

public class ShowTaskList {
	
	public static List<Task> showTasks(int userId) {
		try(Connection conn = DBConnection.getConnection()){
            List<Task> tasks = new ArrayList<>();
            boolean isAdmin = CheckAdmin.isAdmin(userId);
            String getAllUsersSQL = "SELECT t.*, u.username AS userName "
            		+ "FROM tasks AS t "
            		+ "LEFT JOIN users AS u ON t.userId = u.id";
            if(!isAdmin){
            	getAllUsersSQL += " WHERE t.userId = ?";
            }
            PreparedStatement stmtAllUsers = conn.prepareStatement(getAllUsersSQL);
            if(!isAdmin) stmtAllUsers.setInt(1, userId);
            ResultSet rsAllUsers = stmtAllUsers.executeQuery();

            while (rsAllUsers.next()) {
                String taskname = rsAllUsers.getString("task_name");
                String task_desc = rsAllUsers.getString("task_desc");
                String userName = rsAllUsers.getString("userName");
                int id = rsAllUsers.getInt("id");
                tasks.add(new Task(id, taskname, task_desc, userName));
            }
            
            return tasks;
            
		}catch(Exception e) {
			e.printStackTrace();
			return null;
		}
		
	}

}
