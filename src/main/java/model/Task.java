package model;

import java.io.Serializable;

public class Task implements Serializable {
    private static final long serialVersionUID = 1L;
    private int id;
    private String taskname;
    private String desc;
    private String userName;
    
    public Task(int id, String taskname, String desc, String UserName) {
        this.taskname = taskname;
        this.id = id;
        this.desc = desc;
        this.userName = UserName;
    }

    public String getTaskname() {
        return taskname;
    }

    public void setTaskname(String taskname) {
        this.taskname = taskname;
    }
    
    public String getDesc() {
        return desc;
    }

    public void setDesc(String val) {
        this.desc = val;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }
    
    public String getUserName() {
    	return userName;
    }
}
