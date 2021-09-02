package com.bjpowernode.crm.web.filter;

import com.bjpowernode.crm.settings.domain.User;

import javax.servlet.*;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

public class LoginFilter implements Filter {
    public void init(FilterConfig filterConfig) throws ServletException {

    }
    //需要用到的HttpServletRequest中的方法，ServletRequest里都没有，所以要新建HttpServletRequest
    public void doFilter(ServletRequest req, ServletResponse resp, FilterChain chain) throws IOException, ServletException {

        //ServletRequest是父亲，HttpServletRequest是儿子，儿子是基于HTTP协议的，儿子比父亲要具体
        System.out.println("进入到验证有没有登录过的过滤器");
        //上级转下级需要强转，下级转上级不需要
        HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) resp;

        //拿后端路径，前端资源
        String path = request.getServletPath();
        if("/login.jsp".equals(path)||"/settings/user/login.do".equals(path)){
            //不应该被拦截的资源，自动放行请求
            chain.doFilter(req,resp);
        //其它资源必须验证有没有登录过
        }else{

            //取session
            HttpSession session = request.getSession();

            //从session域中取得user
            User user = (User)session.getAttribute("user");

            //如果user不为null,说明登录过,获取到过user对象
            if(user!=null){
                chain.doFilter(req,resp);

                //没有登录过
            }else{
                //重定向到登录页
            /*
                重定向的路径怎么写？
                    在实际项目开发中，对于路径的使用，不论操作的是前端还是后端，应该一律使用绝对路径
                    关于转发和重定向的路径的写法如下：
                    转发：
                        使用的是一种特殊的绝对路径的使用方式，这种路径前面不加/项目名，这种路径也称之为内部路径
                        /Login.jsp
                    重定向：
                        使用的是传统绝对路径的写法，前面必须以/项目名开头，后面跟具体的资源路径
                        /crm/Login.jsp

                为什么使用重定向，使用转发不行吗？
                    转发之后，路径会停留在老路径上，而不是跳转之后最新资源的路径
                    我们应该在为用户跳转到登录页的同时，将浏览器的地址栏应该自动设置为当前的登录页的路径

                ${pageContext.request.contextPath} /项目名

                重定向的原理：重定向指的是服务器把路径给浏览器，浏览器拿到这个请求之后，自动再发出第二次请求，当浏览器再第二次发出这个请求之后，又匹配上了（jsp)，又进入这个过滤器界面，因为都是jsp界面来着
                所以应该有一些资源是我们默认就能访问到的，让我们的请求自动放心，而不需要去判断的
             */
                //"/crm/login.jsp"中，如果项目中有100个重定向/crm就要写100次，而且以后如果搬运项目，需要改项目名的话就很麻烦，所以应该写活，动态获取我当前的项目名
                response.sendRedirect(request.getContextPath()+"/login.jsp");  //request.getContextPath()获取了 /项目名

            }

        }




    }

    public void destroy() {

    }


}
