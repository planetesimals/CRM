package com.bjpowernode.crm.utils;

import java.util.UUID;

public class UUIDUtil {
	
	public static String getUUID(){
		//通过这个工具调这个方法生成一个32位的随机串，去掉了其中的“-”
		return UUID.randomUUID().toString().replaceAll("-","");
		
	}
	
}
