package com.bjpowernode.crm.utils;

import java.lang.reflect.InvocationHandler;
import java.lang.reflect.Method;
import java.lang.reflect.Proxy;

import org.apache.ibatis.session.SqlSession;

public class TransactionInvocationHandler implements InvocationHandler{
	
	private Object target;
	
	public TransactionInvocationHandler(Object target){
		
		this.target = target;
		
	}


	public Object invoke(Object proxy, Method method, Object[] args) throws Throwable {
		
		SqlSession session = null;
		
		Object obj = null;
		
		try{
			session = SqlSessionUtil.getSqlSession();
			
			obj = method.invoke(target, args);  //张三执行了这个login，由李四调张三
			
			session.commit();
		}catch(Exception e){    //张三抛回来了异常，被李四处理完了
			session.rollback();
			e.printStackTrace();
			
			//处理的是什么异常，继续往上抛什么异常
			throw e.getCause();  //让李四处理的异常继续往Controller上抛
		}finally{
			SqlSessionUtil.myClose(session);
		}
		
		return obj;
	}
	
	public Object getProxy(){
		
		return Proxy.newProxyInstance(target.getClass().getClassLoader(), target.getClass().getInterfaces(),this);
		
	}
	
}











































