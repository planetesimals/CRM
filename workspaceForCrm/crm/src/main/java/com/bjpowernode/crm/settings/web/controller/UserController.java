package com.bjpowernode.crm.settings.web.controller;


import com.bjpowernode.crm.settings.domain.User;
import com.bjpowernode.crm.settings.service.UserService;
import com.bjpowernode.crm.settings.service.impl.UserServiceImpl;
import com.bjpowernode.crm.utils.MD5Util;
import com.bjpowernode.crm.utils.PrintJson;
import com.bjpowernode.crm.utils.ServiceFactory;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

public class UserController extends HttpServlet {

    @Override
    protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        System.out.println("进入到用户控制器");

        String path = request.getServletPath();  //它拿到的是web.xml中的url-pattern

        if("/settings/user/login.do".equals(path)){

            login(request,response);
        }else if("/settings/user/xxx.do".equals(path)){

            //xxx(request,response);
        }




    }

    private void login(HttpServletRequest request, HttpServletResponse response) {

        System.out.println("进入到验证登录操作");

        String loginAct = request.getParameter("loginAct");
        String loginPwd = request.getParameter("loginPwd");
        //将密码的明文形式转换为MD5的密文形式
        loginPwd = MD5Util.getMD5(loginPwd);
        //接受浏览器端的ip地址
        String ip = request.getRemoteAddr();
        System.out.println("-------------ip:"+ip);

        //未来业务层开发，统一使用代理类形态的接口对象，方便处理事务
        //getService作用是传张三取李四，传UserServiceImpl真正实现类对象取代理类对象
        UserService us = (UserService) ServiceFactory.getService(new UserServiceImpl());


        //如果us调login方法，业务层抛异常了，登录失败后向controller抛异常，try catch处理异常
        try{

            //us是李四的形态
            //李四形态的us调login方法，就不是UserServiceImpl.java中的login方法了，而是TransactionInvocationHandler（动态代理工具类）的invoke方法了【执行事务】
            User user = us.login(loginAct,loginPwd,ip);  //真正干这件事的时候，出异常了，但异常被李四的代理方法处理完了

            //登录成功后才会执行这行操作，说明业务层没有为controller抛出任何异常
            request.getSession().setAttribute("user",user); //将user保存在session域中

            /*

                 {"success":true}

             */
            PrintJson.printJsonFlag(response,true);  //返回登录成功的json信息


        }catch(Exception e){
            e.printStackTrace();  //拿到了错误信息

            //一旦程序执行了catch块的信息，说明业务层为我们验证登录失败，为controller抛出了异常
            //表示登录失败

            /*

                 {"success":true,"msg":?}

             */
            String msg = e.getMessage(); //错误消息是由业务层提供的
            /*

            我们现在作为controller，需要为ajax请求提供多项信息
            可以有两种手段来处理：
                （1）将多项信息打包成map,将map解析为json串
                （2）创建一个（为前端展现值的对象）Vo
                        private boolean success;
                        private String msg;

            如果对于展现的信息将来还会大量的使用，我们创建了一个vo类，使用方便
            如果对于展现的信息只有在这个需求中能够使用，我们使用map就可以了

             */
            Map<String,Object> map =new HashMap<String,Object>();
            map.put("success",false);
            map.put("msg",msg);
            PrintJson.printJsonObj(response,map);  //输出json格式的数据


        }

    }


}




































