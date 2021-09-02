package com.bjpowernode.crm.exception;


public class LoginException extends Exception{
    //带参数的构造方法，无参数的构造方法可写可不写，这个带参数的构造方法把无参数的构造方法给覆盖掉了
    public LoginException(String msg){

        super(msg);

    }

}
