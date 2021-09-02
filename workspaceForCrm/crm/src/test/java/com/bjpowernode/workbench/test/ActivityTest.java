package com.bjpowernode.workbench.test;

import com.bjpowernode.crm.utils.ServiceFactory;
import com.bjpowernode.crm.utils.UUIDUtil;
import com.bjpowernode.crm.workbench.domain.Activity;
import com.bjpowernode.crm.workbench.service.ActivityService;
import com.bjpowernode.crm.workbench.service.impl.ActivityServiceImpl;
import org.junit.Assert;
import org.junit.Test;


/*

    JUnit:
        单元测试
        是未来实际项目开发中，用来代替主方法main的


 */
public class ActivityTest {

    @Test
    public void testSave(){

        Activity a = new Activity();
        a.setId(UUIDUtil.getUUID());
        a.setName("宣传推广会");
        //以后主要测业务
        ActivityService as = (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());

        boolean flag = as.save(a);
        //断言机制：断定这个flag，它是一个true,如果跟我断定的结果不一样，即使前面的语句正确，juit也报错，如果断定结果一致，测试结果通过
        //经常使用在添加，修改，删除阶段
        Assert.assertEquals(flag, true);


    }

    //@Test
    /*public void testUpdate(){

        String str = null;

        str.length();

        System.out.println("234");

    }*/








}
