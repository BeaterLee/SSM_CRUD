package com.beater.ssm.bean;

import java.util.HashMap;
import java.util.Map;

public class Message {
	private int code;
	private String message;
	private Map<String, Object> extend;

	public static Message success() {
		Message result = new Message();
		result.setCode(100);
		result.setMessage("处理成功");
		return result;
	}

	public static Message fail() {
		Message result = new Message();
		result.setCode(200);
		result.setMessage("处理失败");
		return result;
	}

	public Message add(String key, Object value) {
		this.getExtend().put(key, value);
		return this;
	}

	public int getCode() {
		return code;
	}

	public void setCode(int code) {
		this.code = code;
	}

	public String getMessage() {
		return message;
	}

	public void setMessage(String message) {
		this.message = message;
	}

	public Map<String, Object> getExtend() {
		if (extend == null) {
			extend = new HashMap<>();
		}
		return extend;
	}

	public void setExtend(Map<String, Object> extend) {
		this.extend = extend;
	}
}
