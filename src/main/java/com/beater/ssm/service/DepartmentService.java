package com.beater.ssm.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.beater.ssm.bean.Department;
import com.beater.ssm.dao.DepartmentMapper;

@Service
public class DepartmentService {
	@Autowired
	private DepartmentMapper departmentMapper;
	
	public List<Department> getAllDepartments(){
		List<Department> departments = departmentMapper.selectByExample(null);
		return departments;
	}
}
