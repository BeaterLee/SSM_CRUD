package com.beater.ssm.test;

import static org.junit.Assert.*;

import java.util.Iterator;
import java.util.List;

import javax.servlet.ServletContext;

import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mock.web.MockHttpServletRequest;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.web.WebAppConfiguration;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.MvcResult;
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;
import org.springframework.test.web.servlet.setup.DefaultMockMvcBuilder;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.web.context.WebApplicationContext;

import com.beater.ssm.bean.Employee;
import com.github.pagehelper.PageInfo;

@RunWith(SpringJUnit4ClassRunner.class)
@WebAppConfiguration
@ContextConfiguration(locations = { "classpath:applicationContext.xml",
		"file:src/main/webapp/WEB-INF/DispatcherServlet-servlet.xml" })
public class MockRequestTest {
	MockMvc mockMvc;
	@Autowired
	WebApplicationContext context;

	/**
	 * 初始化MockMvc
	 */
	@Before
	public void initMockMvc() {
		DefaultMockMvcBuilder webAppContextSetup = MockMvcBuilders.webAppContextSetup(context);
		mockMvc = webAppContextSetup.build();
	}

	/**
	 * 模拟Request测试获取所有Employee方法返回的PageInfo
	 * @throws Exception
	 */
	@Test
	public void testGetAllEmployeesWithPageHelper() throws Exception {
		MvcResult result = mockMvc.perform(MockMvcRequestBuilders.get("/emps").param("pageNum", "5")).andReturn();
		MockHttpServletRequest request = result.getRequest();
		PageInfo<Employee> pageInfo = (PageInfo<Employee>) request.getAttribute("pageInfo");
		System.out.println("总页数：" + pageInfo.getPages());
		System.out.println("总条目：" + pageInfo.getTotal());
		System.out.println("当前页码：" + pageInfo.getPageNum());
		for (int i = 0; i < pageInfo.getNavigatePages(); i++) {
			System.out.print(" " + pageInfo.getNavigatepageNums()[i]);
		}
		System.out.println();
		List<Employee> employees = pageInfo.getList();
		for (Employee employee : employees) {
			System.out.println(employee);
		}
	}

}
