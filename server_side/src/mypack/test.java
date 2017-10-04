package mypack;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


public class test extends HttpServlet {

	/**
	 * Constructor of the object.
	 */
	public test() {
		super();
	}

	/**
	 * Destruction of the servlet. <br>
	 */
	public void destroy() {
		super.destroy(); // Just puts "destroy" string in log
		// Put your code here
	}

	
	tools mytool =new tools();
    String message;
    String money;
    private static int parse(char c) {
		if (c >= 'a')
			return (c - 'a' + 10) & 0x0f;
		if (c >= 'A')
			return (c - 'A' + 10) & 0x0f;
		return (c - '0') & 0x0f;
	}
    private byte[] HexString2Bytes(String hexstr) {
		byte[] b = new byte[hexstr.length() / 2];
		int j = 0;
		for (int i = 0; i < b.length; i++) {
			char c0 = hexstr.charAt(j++);
			//System.out.println(c0);
			char c1 = hexstr.charAt(j++);
			//System.out.println(c1);
			b[i] = (byte) ((parse(c0) << 4) | parse(c1));
		}
		return b;
	}
    
    
	
	/**
	 * The doGet method of the servlet. <br>
	 *
	 * This method is called when a form has its tag value method equals to get.
	 * 
	 * @param request the request send by the client to the server
	 * @param response the response send by the server to the client
	 * @throws ServletException if an error occurred
	 * @throws IOException if an error occurred
	 */
	public void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
        
		tools mytool =new tools();
		PrintWriter out = response.getWriter();
		message =request.getParameter("data");
		money =request.getParameter("money");
		String tranMes=mytool.initForLoadProcess(message,money);
		System.out.println(tranMes);
		System.out.println(money);
		out.print(tranMes);
		
			//PrintWriter out = response.getWriter();
			//message =request.getParameter("data");
			/*
			int length = message.length() / 2;
    		byte[] headBytes = new byte[3 + length];
    		byte[] cmdBytes = HexString2Bytes(message);
    		for(int i =0;i<cmdBytes.length;i++){
    			System.out.println(cmdBytes[i]);
    		}*/
    		/*
    		headBytes[0] = (byte)0x02; //sub command type
    		headBytes[1] = (byte)0x01; //command number
    		headBytes[2] = (byte)(length); // command length
    		System.arraycopy(cmdBytes, 0, headBytes, 3, length);
    		int[] cmdInts = new int[3 + length];
    		for (int i = 0; i < 3 + length; i++) {
    			cmdInts[i] = headBytes[i];
    			System.out.println(cmdInts[i]);
    		}
			*/
			
			
		

		out.flush();
		out.close();
	}

	/**
	 * The doPost method of the servlet. <br>
	 *
	 * This method is called when a form has its tag value method equals to post.
	 * 
	 * @param request the request send by the client to the server
	 * @param response the response send by the server to the client
	 * @throws ServletException if an error occurred
	 * @throws IOException if an error occurred
	 */
	public void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		response.setContentType("text/html");
		PrintWriter out = response.getWriter();
		
		out.println("<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01 Transitional//EN\">");
		out.println("<HTML>");
		out.println("  <HEAD><TITLE>A Servlet</TITLE></HEAD>");
		out.println("  <BODY>");
		out.print("    This is ");
		out.print(this.getClass());
		out.println(", using the POST method");
		out.println("  </BODY>");
		out.println("</HTML>");
		out.flush();
		out.close();
	}

	/**
	 * Initialization of the servlet. <br>
	 *
	 * @throws ServletException if an error occurs
	 */
	public void init() throws ServletException {
		// Put your code here
	}

}
