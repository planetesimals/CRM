package com.bjpowernode.crm.web.listener;

import com.bjpowernode.crm.settings.domain.DicValue;
import com.bjpowernode.crm.settings.service.DicService;
import com.bjpowernode.crm.settings.service.impl.DicServiceImpl;
import com.bjpowernode.crm.utils.ServiceFactory;

import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import java.util.*;

//名字：Sys：系统  Init:初始化  ，将数据字典初始化到服务缓存中去，监听哪个域对象就实现哪个接口
public class SysInitListener implements ServletContextListener {

    /*

        该方法是用来监听上下文域对象的方法，当服务器启动，上下文域对象创建
        对象创建完毕后，马上执行该方法

        event：该参数能够取得监听的对象
                监听的是什么对象，就可以通过该参数能取得什么对象
                例如我们现在监听的是上下文域对象，通过该参数就可以取得上下文域对象

     */
    public void contextInitialized(ServletContextEvent event) {

        //System.out.println("上下文域对象创建了");

        System.out.println("服务器缓存处理数据字典开始");
        //取上下域对象
        ServletContext application = event.getServletContext();
        //业务层
        DicService ds = (DicService) ServiceFactory.getService(new DicServiceImpl());

        /*

            应该管业务层要
            7个list

            可以打包成为一个map
            业务层应该是这样来保存数据的：
                map.put("appellationList",dvList1);
                map.put("clueStateList",dvList2);
                map.put("stageList",dvList3);
                ....
                ...




         */
        Map<String, List<DicValue>> map = ds.getAll();
        //将map解析为上下文域对象中保存的键值对
        Set<String> set = map.keySet();
        for(String key:set){
            //取数据字典
            application.setAttribute(key, map.get(key));

        }

        System.out.println("服务器缓存处理数据字典结束");


        //------------------------------------------------------------------------

        //数据字典处理完毕后，处理Stage2Possibility.properties文件
        /*

            处理Stage2Possibility.properties文件步骤：
                解析该文件，将该属性文件中的键值对关系处理成为java中键值对关系（map）

                Map<String(阶段stage),String(可能性possibility)> pMap = ....
                pMap.put("01资质审查",10);
                pMap.put("02需求分析",25);
                pMap.put("07...",...);

                pMap保存值之后，放在服务器缓存中
                application.setAttribute("pMap",pMap);

         */

        //解析properties文件
        //可以直接使用文件类，Properties(java.util),一般使用这个方法处理不涵盖中文的properties文件
        //ResourceBundle(java.util)这个类也是用来处理properties文件的
        Map<String,String> pMap = new HashMap<String,String>();
        //这个文件在src的根下，就不用写路径了，而且用ResourceBundle方法，要把后缀名干掉
        ResourceBundle rb = ResourceBundle.getBundle("Stage2Possibility");
        //什么情况下使用枚举，值（对象）创建好的情况下，不修改了，固定的，例：月份，星期，交通灯
        Enumeration<String> e = rb.getKeys();
        //取key,迭代器中见过，iterator,数据量大的情况下，用迭代器做循环，相当于调优，数据量小的情况下，用foreach做循环，因为迭代器更快
        while (e.hasMoreElements()){

            //阶段
            String key = e.nextElement();
            //可能性
            String value = rb.getString(key);

            pMap.put(key, value);


        }

        //将pMap保存到服务器缓存中
        application.setAttribute("pMap", pMap);



    }

    public void contextDestroyed(ServletContextEvent servletContextEvent) {

    }


}
