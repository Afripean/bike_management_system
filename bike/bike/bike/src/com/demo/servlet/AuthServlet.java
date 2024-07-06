package com.demo.servlet;

import com.demo.service.UserService;
import com.demo.service.impl.UserServiceImpl;
import com.demo.util.TokenBucket;
import com.demo.util.Util;
import com.demo.vo.User;

import javax.imageio.ImageIO;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.awt.*;
import java.awt.image.BufferedImage;
import java.io.IOException;
import java.io.OutputStream;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;
import java.util.concurrent.locks.ReentrantLock;

//@WebServlet("/AuthServlet")
public class AuthServlet extends HttpServlet {
    private static final TokenBucket tokenBucket = new TokenBucket(10, 1, 1000000000); // 每秒补充一个令牌，最大容量为10
    private final ReentrantLock lock = new ReentrantLock(); // 添加锁
    @Override
    public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        if (!tokenBucket.tryConsume()) {
            response.sendError(429, "Too many requests");
            return;
        }

        //过滤编码
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        String action = Util.decode(request, "action");
        if ("login".equalsIgnoreCase(action)) {//登录
            String username = Util.decode(request, "username");
            String password = Util.decode(request, "password");

            String validationCode = Util.decode(request, "validationCode");
            if (validationCode != null && !validationCode.equals(request.getSession().getAttribute("validationCode"))) {//验证码不通过
                request.getSession().setAttribute("alert_msg", "错误：验证码不正确！");
                request.getRequestDispatcher("login.jsp").forward(request, response);
                return;
            }

            UserService userService = new UserServiceImpl();
            Map<String, Object> params = new HashMap();
            
            
            List<User> list = (List<User>) userService.list(params).get("list");
            for (User user : list) {
                if (user.getUsername().equals(username) && user.getPassword().equals(password)) {
                    request.getSession().setAttribute("loginUser", user);
					request.getSession().setMaxInactiveInterval(Integer.MAX_VALUE);

                    if ("管理员".equals(user.getUserType())) {
                        request.getRequestDispatcher("AdminServlet").forward(request, response);
                    }else{
                        request.getRequestDispatcher("UserServlet").forward(request, response);
                    }
                    return;
                }
            }
            request.getSession().setAttribute("alert_msg", "错误：用户名或密码错误！");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        } else if ("register".equalsIgnoreCase(action)) {//注册
            String username = Util.decode(request, "username");
            String password = Util.decode(request, "password");
            System.out.println("username=" + username);
            System.out.println("password=" + password);
            UserService userService = new UserServiceImpl();
            Map<String, Object> params = new HashMap();
            
            
            params.put("startIndex", 0);
            params.put("pageSize", Long.MAX_VALUE);
            List<User> list = (List<User>) userService.list(params).get("list");
            for (User user : list) {
                if (user.getUsername().equals(username) /*&& user.getPassword().equals(password)*/) {//说明该用户名已存在，必须换个用户名才能注册
                    request.getSession().setAttribute("alert_msg", "错误：用户名已存在！");
                    request.getRequestDispatcher("register.jsp").forward(request, response);
                    return;
                }
            }
            User vo = new User();
            vo.setUsername(username);
            vo.setPassword(password);
            vo.setUserType("普通用户");//需要设置一个默认值
            userService.add(vo);
            request.getSession().setAttribute("alert_msg", "注册成功！用户名：[" + username + "]");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        } else if ("logout".equalsIgnoreCase(action)) {//登出
            HttpSession session = request.getSession();
            User user = (User) session.getAttribute("loginUser");
            if (user != null) {
                session.removeAttribute("loginUser");
            }
            response.sendRedirect("login.jsp");
        } else if ("validationCode".equalsIgnoreCase(action)) {
            String codeChars = "0123456789";// 图形验证码的字符集合，系统将随机从这个字符串中选择一些字符作为验证码
            //  获得验证码集合的长度
            int charsLength = codeChars.length();

            response.setHeader("ragma", "No-cache");
            response.setHeader("Cache-Control", "no-cache");
            response.setDateHeader("Expires", 0);
            //  设置图形验证码的长和宽（图形的大小）
            int width = 90, height = 20;
            BufferedImage image = new BufferedImage(width, height, BufferedImage.TYPE_INT_RGB);
            Graphics g = image.getGraphics();//  获得用于输出文字的Graphics对象
            Random random = new Random();
            g.setColor(getRandomColor(180, 250));// 随机设置要填充的颜色
            g.fillRect(0, 0, width, height);//  填充图形背景
            //  设置初始字体
            g.setFont(new Font("Times New Roman", Font.ITALIC, height));
            g.setColor(getRandomColor(120, 180));// 随机设置字体颜色
            //  用于保存最后随机生成的验证码
            StringBuilder validationCode = new StringBuilder();
            //  验证码的随机字体
            String[] fontNames = {"Times New Roman", "Book antiqua", "Arial"};
            for (int i = 0; i < 4; i++) {
                //  随机设置当前验证码的字符的字体
                g.setFont(new Font(fontNames[random.nextInt(3)], Font.ITALIC, height));
                //  随机获得当前验证码的字符
                char codeChar = codeChars.charAt(random.nextInt(charsLength));
                validationCode.append(codeChar);
                //  随机设置当前验证码字符的颜色
                g.setColor(getRandomColor(10, 100));
                //  在图形上输出验证码字符，x和y都是随机生成的
                g.drawString(String.valueOf(codeChar), 16 * i + random.nextInt(7), height - random.nextInt(6));
            }
            HttpSession session = request.getSession();
            session.setMaxInactiveInterval(5 * 60);
            //  将验证码保存在session对象中，key为validation_code
            session.setAttribute("validationCode", validationCode.toString());
            g.dispose();//  关闭Graphics对象
            OutputStream os = response.getOutputStream();
            ImageIO.write(image, "JPEG", os);// 以JPEG格式向客户端发送图形验证码
        } else if ("resetPassword".equalsIgnoreCase(action)) {
            String msg;
            User loginUser = (User) request.getSession().getAttribute("loginUser");
            String oldPassword = Util.decode(request, "oldPassword");
            if (!loginUser.getPassword().equals(oldPassword)) {
                msg = "原密码错误！";
            } else {
                String newPassword = Util.decode(request, "newPassword");
                loginUser.setPassword(newPassword);
                UserService userService = new UserServiceImpl();
                userService.update(loginUser);
                msg = "修改成功！";
            }
            request.getSession().setAttribute("alert_msg", msg);
            request.getRequestDispatcher("reset_password.jsp").forward(request, response);
        } else {
            response.sendRedirect("login.jsp");
        }

    }

    /**
     * 处理Get请求
     *
     * @param request
     * @param response
     * @throws ServletException
     * @throws IOException
     */
    @Override
    public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request, response);
    }

    // 返回一个随机颜色（Color对象）
    private Color getRandomColor(int minColor, int maxColor) {
        Random random = new Random();
        // 保存minColor最大不会超过255
        if (minColor > 255)
            minColor = 255;
        //  保存minColor最大不会超过255
        if (maxColor > 255)
            maxColor = 255;
        //  获得红色的随机颜色值
        int red = minColor + random.nextInt(maxColor - minColor);
        //  获得绿色的随机颜色值
        int green = minColor + random.nextInt(maxColor - minColor);
        //  获得蓝色的随机颜色值
        int blue = minColor + random.nextInt(maxColor - minColor);
        return new Color(red, green, blue);
    }
}
