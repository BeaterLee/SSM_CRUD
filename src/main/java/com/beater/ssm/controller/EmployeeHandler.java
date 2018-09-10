package com.beater.ssm.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.validation.Valid;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.beater.ssm.bean.Employee;
import com.beater.ssm.bean.Message;
import com.beater.ssm.service.EmployeeService;
import com.github.pagehelper.PageInfo;

@Controller
public class EmployeeHandler {
	@Autowired
	private EmployeeService employeeService;
	
	/**
	 * 响应/emps请求,将查询的所有Employee分页后的pageInfo放入request域中
	 * 缺点：缺少无关平台性，适配不好
	 * @param pageNum
	 * @param map
	 * @return
	 */
	//@RequestMapping(value = { "/emps" })
	public String getEmployees(
			@RequestParam(name = "pageNum", required = false, defaultValue = "1") Integer pageNum,
			Map<String,Object> map) {
		PageInfo<Employee> pageInfo = employeeService.getAllEmployees(8, pageNum);
		map.put("pageInfo", pageInfo);
		return "list";
	}
	
	/**
	 * 响应AJAX请求，获取所有员工数据
	 * @param pageNum
	 * @return
	 */
	@RequestMapping(value = { "/emps" })
	@ResponseBody
	public Message getEmployees(@RequestParam(name = "pageNum", required = false, defaultValue = "1") Integer pageNum) {
		PageInfo<Employee> pageInfo = employeeService.getAllEmployees(8, pageNum);
		return Message.success().add("pageInfo", pageInfo);
	}
	
	/**
	 * 这里使用了JSR-303后台校验
	 * @param employee
	 * @param bindingResult
	 * @return
	 */
	@RequestMapping(value = { "/emp" },method= {RequestMethod.POST})
	@ResponseBody
	public Message saveEmployee(@Valid Employee employee,BindingResult bindingResult) {
		Map<String,Object> errorMap = new HashMap<>();
		if(bindingResult.hasErrors()) {
			List<FieldError> fieldErrors = bindingResult.getFieldErrors();
			for (FieldError fieldError : fieldErrors) {
				errorMap.put(fieldError.getField(), fieldError.getDefaultMessage());
			}
			return Message.fail().add("errorMap", errorMap);
		}
		if(!employeeService.checkLastNameUnique(employee.getLastName())){
			errorMap.put("lastNameExist",  "用户名已存在");
			return Message.fail().add("errorMap",errorMap);
		}
		employeeService.saveEmployee(employee);
		return Message.success();
	}
	
	/**
	 * 检查用户名唯一性
	 * @param lastName
	 * @return
	 */
	@RequestMapping(value = {"/nameUnique"})
	@ResponseBody
	public Message checkLastNameUnique(String lastName) {
		String regex = "(^[a-zA-Z0-9_-]{6,16}$)|(^[\u2E80-\u9FFF]{2,5})";
		if(!lastName.matches(regex)) {
			return Message.fail().add("valid_result", "用户名应该为2-5个汉字或6-16个字母（横杠，下划线）");
		}
		boolean flag = employeeService.checkLastNameUnique(lastName);
		if(flag) {
			return Message.success();
		}else {
			return Message.fail().add("valid_result", "用户名不可用");
		}
	}
	
	/**
	 * 响应AJAX请求，获取指定ID员工的数据 
	 * @param id
	 * @return
	 */
	@RequestMapping(value= {"/emp/{id}"},method= {RequestMethod.GET})
	@ResponseBody
	public Message getEmployeeById(@PathVariable Integer id) {
		Employee employee = employeeService.getEmployeeById(id);
		return Message.success().add("emp", employee);
	}
	
	/**
	 * 更新员工数据
	 * @param employee
	 * @return
	 */
	@RequestMapping(value= {"/emp/{id}"}, method= {RequestMethod.PUT})
	@ResponseBody
	public Message updateEmployee(Employee employee) {
		employeeService.updateEmployee(employee);
		return Message.success();
	}
	
	/**
	 * 删除(单个，批量)员工数据
	 * @param id
	 * @return
	 */
	@RequestMapping(value= {"/emp/{idString}"}, method= {RequestMethod.DELETE})
	@ResponseBody
	public Message deleteEmployee(@PathVariable String idString) {
		employeeService.deleteEmployee(idString);
		return Message.success();
	}
}
