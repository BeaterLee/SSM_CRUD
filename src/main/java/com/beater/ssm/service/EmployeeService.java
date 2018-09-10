package com.beater.ssm.service;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.beater.ssm.bean.Employee;
import com.beater.ssm.bean.EmployeeExample;
import com.beater.ssm.bean.EmployeeExample.Criteria;
import com.beater.ssm.dao.EmployeeMapper;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;

@Service
public class EmployeeService {
	@Autowired
	private EmployeeMapper employeeMapper;
	
	/**
	 * 返回查询的所有Employee分页后的pageInfo
	 * @return
	 */
	public PageInfo<Employee> getAllEmployees(Integer numPerPage,Integer pageNum){
		EmployeeExample employeeExample = new EmployeeExample();
		employeeExample.setOrderByClause("id ASC");
		PageHelper.startPage(pageNum, 8);
		List<Employee> employees = employeeMapper.selectByExampleWithDepartment(employeeExample);
		PageInfo<Employee> pageInfo = new PageInfo<>(employees, 5);
		return pageInfo;
	}
	
	/**
	 *  保存Employee
	 * @param employee
	 */
	public void saveEmployee(Employee employee) {
		// TODO Auto-generated method stub
		employeeMapper.insertSelective(employee);
		return;
	}
	
	/**
	 *  校验lastName唯一性
	 * @param lastName
	 * @return
	 */
	public boolean checkLastNameUnique(String lastName) {
		// TODO Auto-generated method stub
		EmployeeExample employeeExample = new EmployeeExample();
		Criteria criteria = employeeExample.createCriteria();
		criteria.andLastNameEqualTo(lastName);
		long count = employeeMapper.countByExample(employeeExample);
		return count == 0;
	}

	/**
	 * 获取指定ID的员工数据
	 * @param id
	 * @return
	 */
	public Employee getEmployeeById(Integer id) {
		// TODO Auto-generated method stub
		Employee employee = employeeMapper.selectByPrimaryKey(id);
		return employee;
	}

	/**
	 * 更新员工数据
	 * @param employee
	 */
	public void updateEmployee(Employee employee) {
		// TODO Auto-generated method stub
		employeeMapper.updateByPrimaryKeySelective(employee);
	}
	
	/**
	 * 删除员工
	 * @param id
	 */
	public void deleteEmployee(String idString) {
		// TODO Auto-generated method stub
		List<Integer> idList = new ArrayList<>();
		String[] ids = idString.split("-");
		for (String id : ids) {
			idList.add(Integer.parseInt(id));
		}
		EmployeeExample example = new EmployeeExample();
		Criteria criteria = example.createCriteria();
		criteria.andIdIn(idList);
		employeeMapper.deleteByExample(example);
	}
}

