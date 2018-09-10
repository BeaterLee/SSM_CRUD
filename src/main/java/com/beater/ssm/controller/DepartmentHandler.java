package com.beater.ssm.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.beater.ssm.bean.Department;
import com.beater.ssm.bean.Message;
import com.beater.ssm.service.DepartmentService;

@Controller
public class DepartmentHandler {
	@Autowired
	private DepartmentService departmentService;
	
	@RequestMapping(value = {"/depts"})
	@ResponseBody
	public Message getAllDepartments() {
		List<Department> departments = departmentService.getAllDepartments();
		return Message.success().add("departments", departments);
	}
}
