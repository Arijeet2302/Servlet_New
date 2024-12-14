package util;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import DB.DBConnection;

public class CheckAdmin {
	
	public static boolean isAdmin(int userId) {
		try(Connection conn = DBConnection.getConnection()){
            String getAllUsersSQL = "SELECT role FROM users WHERE id = ?";
            PreparedStatement stmtAllUsers = conn.prepareStatement(getAllUsersSQL);
            stmtAllUsers.setInt(1, userId);
            ResultSet rsAllUsers = stmtAllUsers.executeQuery();

            while (rsAllUsers.next()) {
                String role = rsAllUsers.getString("role");
                if(role.equals("Admin")) {
                	return true;
                }  
            }
            
            return false;
		}catch(Exception e) {
			e.printStackTrace();
			return false;
		}
	}
}
