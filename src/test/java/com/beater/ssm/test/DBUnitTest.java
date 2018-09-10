package com.beater.ssm.test;

import java.util.Iterator;
import java.util.List;
import java.util.UUID;

import org.apache.ibatis.session.SqlSession;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import com.beater.ssm.bean.Department;
import com.beater.ssm.bean.DepartmentExample;
import com.beater.ssm.bean.Employee;
import com.beater.ssm.bean.EmployeeExample;
import com.beater.ssm.bean.EmployeeExample.Criteria;
import com.beater.ssm.dao.DepartmentMapper;
import com.beater.ssm.dao.EmployeeMapper;

/**
 * 使用spring-test进行单元测试： 1.导入spring-test的jar包。
 * 2.在测试类上使用@ContextConfiguratio,利用locations指定springioc容器配置文件的路径
 * 3.在测试类上使用@RunWith，指定使用SpringJUnit4ClassRunner
 * 
 * @author 74597
 */
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = { "classpath:applicationContext.xml" })
public class DBUnitTest {
	@Autowired
	EmployeeMapper employeeMapper;
	@Autowired
	DepartmentMapper departmentMapper;
	@Autowired
	SqlSession sqlSession;

	@Test
	public void testEmployeeCRUD() {
		EmployeeExample example = new EmployeeExample();
		Criteria criteria = example.createCriteria();
		// 测试查询(通过)
		// criteria.andDeptIdIsNotNull();
		// List<Employee> list = employeeMapper.selectByExample(example);
		// List<Employee> list = employeeMapper.selectByExampleWithDepartment(example);
		// for (Employee employee : list) {
		// System.out.println(employee);
		// }
		// Employee employee = employeeMapper.selectByPrimaryKeyWithDepartment(1);
		// System.out.println(employee);
		// 测试修改(通过)
		// criteria.andLastNameEqualTo("Tom");
		// employeeMapper.updateByExampleSelective(new Employee(null,"Toms", null, null,
		// null), example);
		// employeeMapper.updateByPrimaryKeySelective(new Employee(1, "Tom", null, null,
		// null));
		// 测试插入(通过)
		// employeeMapper.insertSelective(new Employee(null, "Zoom", "1", "bb@163.com",
		// 1));
		// 测试删除(通过)
		// criteria.andEmailEqualTo("bb@163.com");
		// employeeMapper.deleteByExample(example);
		// employeeMapper.deleteByPrimaryKey(5);
	}

	@Test
	public void testDepartmentCRUD() {
		DepartmentExample example = new DepartmentExample();
		com.beater.ssm.bean.DepartmentExample.Criteria criteria = example.createCriteria();
		// 测试查询(通过)
		// criteria.andIdIsNotNull();
		// List<Department> departments = departmentMapper.selectByExample(example);
		// for (Department department : departments) {
		// System.out.println(department);
		// }
		// Department department = departmentMapper.selectByPrimaryKey(1);
		// System.out.println(department);
		// 测试修改(通过)
		// criteria.andNameEqualTo("开发部");
		// departmentMapper.updateByExampleSelective(new Department(null, "研发部"),
		// example);
		// departmentMapper.updateByPrimaryKeySelective(new Department(1, "开发部"));
		// 测试插入(通过)
		// departmentMapper.insertSelective(new Department(null, "市场部"));
		// 测试删除(通过)
		// criteria.andNameEqualTo("市场部");
		// departmentMapper.deleteByExample(example);
		// employeeMapper.deleteByPrimaryKey(5);
	}

	@Test
	public void testBatchInsert() {
		// 测试批量插入(成功)
		EmployeeMapper employeeMapper = sqlSession.getMapper(EmployeeMapper.class);
		for (int i = 0; i < 100; i++) {
			String uid = UUID.randomUUID().toString().substring(0, 5) + i;
			employeeMapper.insertSelective(new Employee(null, uid, "1", uid + "@beater.com", 1));
		}
		System.out.println("批量插入成功");
	}
	
}
